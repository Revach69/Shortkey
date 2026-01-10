import * as functions from 'firebase-functions';
import { RequestContext } from '../types/server';
import { getDevice } from '../services/collections/deviceCollection';
import { verifySignature } from './crypto';
import { checkRateLimit } from '../services/collections/rateLimitCollection';

export async function getRequestContext(
  deviceId: string,
  signature: string,
  requestData: Record<string, any>
): Promise<RequestContext> {
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

  const device = await getDevice(deviceId);
  if (!device || !device.publicKey) {
    throw new functions.https.HttpsError('not-found', 'Device not registered');
  }

  const isValid = verifySignature(requestData, signature, device.publicKey);
  if (!isValid) {
    throw new functions.https.HttpsError('unauthenticated', 'Invalid signature');
  }

  await checkRateLimit(deviceId, device.tier);

  return { device };
}
