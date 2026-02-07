import * as admin from 'firebase-admin';
import { Tier, TierType } from '../../types/models';
import { COLLECTIONS } from '../../constants';

const db = admin.firestore();

export function getDeviceRef(deviceId: string) {
  return db.collection(COLLECTIONS.DEVICES).doc(deviceId);
}

export async function getDevice(deviceId: string): Promise<any | null> {
  const doc = await getDeviceRef(deviceId).get();
  return doc.exists ? doc.data() : null;
}

export async function getDeviceTier(deviceId: string): Promise<TierType> {
  const device = await getDevice(deviceId);
  if (device?.tier === Tier.PRO) return Tier.PRO;
  if (device?.tier === Tier.BYOK) return Tier.BYOK;
  return Tier.FREE;
}

export async function createDevice(
  deviceId: string,
  publicKey: string,
  tier: TierType,
  monthlyCount: number,
  lastReset: string,
  timestamp: admin.firestore.FieldValue
): Promise<void> {
  await getDeviceRef(deviceId).set({
    deviceId,
    publicKey,
    tier,
    monthlyCount,
    lastReset,
    firstSeen: timestamp,
    lastSeen: timestamp,
  });
}
