import * as functions from 'firebase-functions';
import { RegisterDeviceRequest } from './index';
import { isValidPublicKey } from '../../utils/crypto';

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

  if (!isValidPublicKey(data.publicKey)) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Invalid public key format'
    );
  }
}
