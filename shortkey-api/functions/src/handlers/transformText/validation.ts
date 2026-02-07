import * as functions from 'firebase-functions';
import { TierType } from '../../types/models';
import { CONFIG } from '../../config';

/**
 * Validates text transformation request
 */
export function validateTransformRequest(
  data: any,
  tier: TierType
): void {
  if (!data.text || typeof data.text !== 'string') {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Invalid text. Must be a non-empty string.'
    );
  }

  if (!data.instruction || typeof data.instruction !== 'string') {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Invalid instruction. Must be a non-empty string.'
    );
  }

  const maxLength = CONFIG.tiers[tier].maxTextLength;
  if (data.text.length > maxLength) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      `Text too long. Maximum ${maxLength} characters for ${tier} tier.`
    );
  }
}
