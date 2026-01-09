import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { RegisterDeviceRequest, TransformRequest, TransformResponse } from './types';
import { validateRegisterDeviceRequest, validateTransformRequest } from './validation';
import { verifySignature } from './crypto';
import { registerDevice as registerDeviceService, getDevice } from './services/deviceCollection';
import { checkRateLimit } from './services/rateLimitCollection';
import { checkAndIncrementQuota } from './services/quotaService';
import { transformText } from './services/openAiApi';
import { logUsage } from './services/analyticsCollection';

admin.initializeApp();

export const registerDevice = functions
  .https.onCall(async (request: functions.https.CallableRequest<RegisterDeviceRequest>) => {
    const data = request.data;
    validateRegisterDeviceRequest(data);
    
    await registerDeviceService(data.deviceId, data.publicKey);
    
    return { success: true };
  });

export const transform = functions
  .runWith({
    timeoutSeconds: 30,
    memory: '256MB',
  })
  .https.onCall(async (data: TransformRequest): Promise<TransformResponse> => {
    const { deviceId, text, instruction, signature } = data;
    
    const device = await getDevice(deviceId);
    if (!device || !device.publicKey) {
      throw new functions.https.HttpsError(
        'not-found',
        'Device not registered. Call registerDevice first.'
      );
    }
    
    const tier = device.tier;
    validateTransformRequest(data, tier);
    
    const isValid = verifySignature({ deviceId, text, instruction }, signature, device.publicKey);
    
    if (!isValid) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'Invalid signature'
      );
    }
    
    try {
      await checkRateLimit(deviceId, tier);
      const quota = await checkAndIncrementQuota(deviceId, tier);
      const result = await transformText(text, instruction);
      await logUsage(deviceId, tier, text.length, true);
      
      return { result, quota };
    } catch (error: any) {
      await logUsage(deviceId, tier, text.length, false);
      throw error;
    }
  });
