import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { TierType } from '../types';
import { CONFIG } from '../config';
import { Collections } from '../constants';

const db = admin.firestore();

function getCurrentMinute(): number {
  return Math.floor(Date.now() / 60000);
}

export async function checkRateLimit(
  deviceId: string,
  tier: TierType
): Promise<void> {
  const currentMinute = getCurrentMinute();
  const limit = CONFIG.tiers[tier].burst;
  
  const rateLimitRef = db
    .collection(Collections.RATE_LIMITS)
    .doc(`${deviceId}_${currentMinute}`);
  
  await db.runTransaction(async (transaction) => {
    const doc = await transaction.get(rateLimitRef);
    const count = doc.exists ? (doc.data()!.count || 0) : 0;
    
    if (count >= limit) {
      throw new functions.https.HttpsError(
        'resource-exhausted',
        `Rate limit exceeded. Maximum ${limit} requests per minute.`
      );
    }
    
    transaction.set(rateLimitRef, {
      count: count + 1,
      expiresAt: admin.firestore.Timestamp.fromMillis(Date.now() + 120000),
    });
  });
}
