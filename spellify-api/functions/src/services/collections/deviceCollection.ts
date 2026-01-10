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
  return device?.tier === Tier.PRO ? Tier.PRO : Tier.FREE;
}

export async function createDevice(
  deviceId: string,
  publicKey: string,
  tier: TierType,
  dailyCount: number,
  lastReset: string,
  timestamp: admin.firestore.FieldValue
): Promise<void> {
  await getDeviceRef(deviceId).set({
    deviceId,
    publicKey,
    tier,
    dailyCount,
    lastReset,
    firstSeen: timestamp,
    lastSeen: timestamp,
  });
}
