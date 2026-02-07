import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { TierType, QuotaInfo } from '../types/models';
import { COLLECTIONS } from '../constants';
import { CONFIG } from '../config';
import { getCurrentMonthString, getNextMonthFirstDayISO, getServerTimestamp } from '../utils/dateHelpers';

const db = admin.firestore();

export async function checkAndIncrementQuota(
  deviceId: string,
  tier: TierType
): Promise<QuotaInfo> {
  const currentMonth = getCurrentMonthString();
  const limit = CONFIG.tiers[tier].monthly;

  const deviceRef = db.collection(COLLECTIONS.DEVICES).doc(deviceId);

  const result = await db.runTransaction(async (transaction) => {
    const doc = await transaction.get(deviceRef);

    if (!doc.exists) {
      throw new functions.https.HttpsError(
        'not-found',
        'Device not registered. Call registerDevice first.'
      );
    }

    const device = doc.data()!;

    if (device.lastReset !== currentMonth) {
      device.monthlyCount = 0;
      device.lastReset = currentMonth;
    }

    if (device.monthlyCount >= limit) {
      throw new functions.https.HttpsError(
        'resource-exhausted',
        `Monthly limit reached. Limit: ${limit} requests per month. Upgrade to Pro for 2,000 actions/month ($9/mo).`
      );
    }

    device.monthlyCount++;
    device.lastSeen = getServerTimestamp();

    transaction.set(deviceRef, device);

    return { used: device.monthlyCount, limit };
  });

  return {
    ...result,
    resetsAt: getNextMonthFirstDayISO(),
  };
}
