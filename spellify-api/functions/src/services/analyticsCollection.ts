import * as admin from 'firebase-admin';
import { TierType } from '../types';
import { CONFIG } from '../config';
import { Collections } from '../constants';

const db = admin.firestore();

export async function logUsage(
  deviceId: string,
  tier: TierType,
  textLength: number,
  success: boolean
): Promise<void> {
  await db.collection(Collections.USAGE_LOGS).add({
    deviceId,
    tier,
    textLength,
    success,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
    model: CONFIG.openai.model,
  });
}
