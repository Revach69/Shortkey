import * as admin from 'firebase-admin';
import { Collections } from '../../constants';

const db = admin.firestore();

export async function incrementRateLimitIfAllowed(
  deviceId: string,
  currentMinute: number,
  maxLimit: number
): Promise<void> {
  const rateLimitRef = db
    .collection(Collections.RATE_LIMITS)
    .doc(`${deviceId}_${currentMinute}`);

  await db.runTransaction(async (transaction: admin.firestore.Transaction) => {
    const doc = await transaction.get(rateLimitRef);
    const count = doc.exists ? (doc.data()!.count || 0) : 0;

    if (count >= maxLimit) {
      throw new Error(`Rate limit exceeded. Maximum ${maxLimit} requests per minute.`);
    }

    transaction.set(rateLimitRef, {
      count: count + 1,
      expiresAt: admin.firestore.Timestamp.fromMillis(Date.now() + 120000),
    });
  });
}
