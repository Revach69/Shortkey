import * as crypto from 'crypto';
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { validateRegisterDeviceRequest } from './validation';
import { createDevice } from '../../services/collections/deviceCollection';
import { getServerTimestamp, getCurrentMonthString } from '../../utils/dateHelpers';
import { Tier } from '../../types/models';
import { COLLECTIONS, REGISTER_RATE_LIMIT_PER_HOUR } from '../../constants';

export interface RegisterDeviceRequest {
  deviceId: string;
  publicKey: string;
}

// NOTE: Client must include 'timestamp: Date.now()' in signed request data
export async function registerDeviceHandler(
  data: RegisterDeviceRequest,
  clientIp: string | undefined
): Promise<{ success: boolean }> {
  validateRegisterDeviceRequest(data);

  await checkRegistrationRateLimit(clientIp);

  const now = getServerTimestamp();
  const currentMonth = getCurrentMonthString();

  await createDevice(data.deviceId, data.publicKey, Tier.FREE, 0, currentMonth, now);

  return { success: true };
}

async function checkRegistrationRateLimit(clientIp: string | undefined): Promise<void> {
  if (!clientIp) {
    return;
  }

  const db = admin.firestore();
  const currentHour = new Date().toISOString().slice(0, 13); // e.g. "2026-02-07T14"
  const rawKey = `${clientIp}_${currentHour}`;
  const docId = crypto.createHash('sha256').update(rawKey).digest('hex');

  const ref = db.collection(COLLECTIONS.REGISTRATION_RATE_LIMITS).doc(docId);

  await db.runTransaction(async (transaction: admin.firestore.Transaction) => {
    const doc = await transaction.get(ref);
    const count = doc.exists ? (doc.data()!.count || 0) : 0;

    if (count >= REGISTER_RATE_LIMIT_PER_HOUR) {
      throw new functions.https.HttpsError(
        'resource-exhausted',
        'Too many registration attempts. Try again later.'
      );
    }

    transaction.set(ref, {
      count: count + 1,
      expiresAt: admin.firestore.Timestamp.fromMillis(Date.now() + 2 * 60 * 60 * 1000),
    });
  });
}
