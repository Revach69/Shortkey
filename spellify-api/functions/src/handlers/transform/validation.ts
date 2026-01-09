import * as functions from 'firebase-functions';
import { TierType } from '../../types';
import { CONFIG } from '../../config';

/**
 * Validates text transformation request
 */
export function validateTransformRequest(
  data: any,
  tier: TierType
): void {
  if (!data.text || !data.instruction || !data.deviceId) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Missing required fields: text, instruction, deviceId'
    );
  }

  if (!data.signature || typeof data.signature !== 'string') {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Missing or invalid signature'
    );
  }

  const maxLength = CONFIG.tiers[tier].maxTextLength;
  if (data.text.length > maxLength) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      `Text too long. Maximum ${maxLength} characters for ${tier} tier.`
    );
  }

  if (typeof data.deviceId !== 'string' || data.deviceId.length === 0) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Invalid deviceId'
    );
  }
}
