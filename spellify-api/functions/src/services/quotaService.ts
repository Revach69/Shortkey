import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { TierType, QuotaInfo } from '../types';
import { CONFIG } from '../config';
import { Collections } from '../constants';

const db = admin.firestore();

function getTodayString(): string {
  return new Date().toISOString().split('T')[0];
}

function getNextMidnightISO(): string {
  const tomorrow = new Date();
  tomorrow.setUTCDate(tomorrow.getUTCDate() + 1);
  tomorrow.setUTCHours(0, 0, 0, 0);
  return tomorrow.toISOString();
}

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
    device.lastSeen = admin.firestore.FieldValue.serverTimestamp();
    
    transaction.set(deviceRef, device);
    
    return { used: device.dailyCount, limit };
  });
  
  return {
    ...result,
    resetsAt: getNextMidnightISO(),
  };
}
