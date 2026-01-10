import * as functions from 'firebase-functions';
import { TierType } from '../../types/models';
import { CONFIG } from '../../config';
import { getCurrentMinute } from '../../utils/dateHelpers';
import { incrementRateLimitIfAllowed } from '../../services/collections/rateLimitCollection';

export async function checkRateLimit(
  deviceId: string,
  tier: TierType
): Promise<void> {
  const currentMinute = getCurrentMinute();
  const limit = CONFIG.tiers[tier].burst;

  try {
    await incrementRateLimitIfAllowed(deviceId, currentMinute, limit);
  } catch (error: any) {
    throw new functions.https.HttpsError('resource-exhausted', error.message);
  }
}
