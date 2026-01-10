import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { TierType, QuotaInfo } from '../types/models';
import { Collections } from '../constants';
import { CONFIG } from '../config';
import { getTodayString, getNextMidnightISO, getServerTimestamp } from '../utils/dateHelpers';

const db = admin.firestore();

export async function checkAndIncrementQuota(
  deviceId: string,
  tier: TierType
): Promise<QuotaInfo> {
  const today = getTodayString();
  const limit = CONFIG.tiers[tier].daily;
  
  const deviceRef = db.collection(Collections.DEVICES).doc(deviceId);
  
  const result = await db.runTransaction(async (transaction) => {
    const doc = await transaction.get(deviceRef);
    
    if (!doc.exists) {
      throw new functions.https.HttpsError(
        'not-found',
        'Device not registered. Call registerDevice first.'
      );
    }
    
    const device = doc.data()!;
    
    if (device.lastReset !== today) {
      device.dailyCount = 0;
      device.lastReset = today;
    }
    
    if (device.dailyCount >= limit) {
      throw new functions.https.HttpsError(
        'resource-exhausted',
        `Daily quota exceeded. Limit: ${limit} requests per day.`
      );
    }
    
    device.dailyCount++;
    device.lastSeen = getServerTimestamp();
    
    transaction.set(deviceRef, device);
    
    return { used: device.dailyCount, limit };
  });
  
  return {
    ...result,
    resetsAt: getNextMidnightISO(),
  };
}
