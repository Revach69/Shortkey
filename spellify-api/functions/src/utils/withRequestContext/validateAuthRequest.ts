import * as functions from 'firebase-functions';

export function validateAuthRequest(deviceId: string, signature: string): void {
  if (!deviceId || typeof deviceId !== 'string' || deviceId.length === 0) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Invalid deviceId. Must be a non-empty string.'
    );
  }

  if (!signature || typeof signature !== 'string' || signature.length === 0) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Invalid signature. Must be a non-empty string.'
    );
  }
}
