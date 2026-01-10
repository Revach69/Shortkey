import * as functions from 'firebase-functions';
import { RegisterDeviceRequest } from './index';

/**
 * Validates device registration request
 */
export function validateRegisterDeviceRequest(data: RegisterDeviceRequest): void {
  if (!data.deviceId || typeof data.deviceId !== 'string') {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Invalid deviceId'
    );
  }

  if (!data.publicKey || typeof data.publicKey !== 'string') {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Invalid publicKey'
    );
  }
}
