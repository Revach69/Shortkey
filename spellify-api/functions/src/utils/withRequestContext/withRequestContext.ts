import * as functions from 'firebase-functions';
import { AuthenticatedHandler } from '../../types/server';
import { getDevice } from '../../services/collections/deviceCollection';
import { verifySignature } from '../crypto';
import { checkRateLimit } from './checkRateLimit';
import { validateAuthRequest } from './validateAuthRequest';

interface AuthenticatedRequest {
  deviceId: string;
  signature: string;
  [key: string]: any;
}

/**
 * Higher-Order Function that wraps authenticated handlers
 * Extracts request context (device lookup, signature verification, rate limiting)
 * and injects it into the handler
 * 
 * @param handler - The authenticated handler function
 * @returns Wrapped handler for use with functions.https.onCall
 */
export function withRequestContext<TRequest extends AuthenticatedRequest, TResponse>(
  handler: AuthenticatedHandler<TRequest, TResponse>
) {
  return async (request: functions.https.CallableRequest<TRequest>): Promise<TResponse> => {
    const data = request.data;
    const { deviceId, signature } = data;
    
    validateAuthRequest(deviceId, signature);

    const device = await getDevice(deviceId);
    if (!device || !device.publicKey) {
      throw new functions.https.HttpsError('not-found', 'Device not registered');
    }

    const isValid = verifySignature(data, signature, device.publicKey);
    if (!isValid) {
      throw new functions.https.HttpsError('unauthenticated', 'Invalid signature');
    }

    await checkRateLimit(deviceId, device.tier);

    return handler(data, { device });
  };
}
