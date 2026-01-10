import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { Tier, TierType } from '../../types/models';
import { isValidPublicKey } from '../../utils/crypto';
import { Collections } from '../../constants';

const db = admin.firestore();

function getTodayString(): string {
  return new Date().toISOString().split('T')[0];
}

export async function registerDevice(
  deviceId: string,
  publicKey: string
): Promise<void> {
  if (!isValidPublicKey(publicKey)) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Invalid public key format'
    );
  }

  const now = admin.firestore.FieldValue.serverTimestamp();

  await db.collection(Collections.DEVICES).doc(deviceId).set({
    deviceId,
    publicKey,
    tier: Tier.FREE,
    dailyCount: 0,
    lastReset: getTodayString(),
    firstSeen: now,
    lastSeen: now,
  });
}

export async function getDevice(deviceId: string): Promise<any | null> {
  const doc = await db.collection(Collections.DEVICES).doc(deviceId).get();
  return doc.exists ? doc.data() : null;
}

export async function getDeviceTier(deviceId: string): Promise<TierType> {
  const device = await getDevice(deviceId);
  return device?.tier === Tier.PRO ? Tier.PRO : Tier.FREE;
}
