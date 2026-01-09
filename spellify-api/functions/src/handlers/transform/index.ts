import * as functions from 'firebase-functions';
import { TransformRequest, TransformResponse } from '../../types';
import { validateTransformRequest } from './validation';
import { verifySignature } from '../../utils/crypto';
import { getDevice } from '../../services/deviceCollection';
import { checkRateLimit } from '../../services/rateLimitCollection';
import { checkAndIncrementQuota } from '../../services/quotaService';
import { transformText } from '../../services/openAiApi';
import { logUsage } from '../../services/analyticsCollection';

/**
 * Handler for text transformation
 * Validates signature, checks limits, transforms text via OpenAI
 */
export async function transformHandler(data: TransformRequest): Promise<TransformResponse> {
  const { deviceId, text, instruction, signature } = data;
  
  // Get device and verify it exists
  const device = await getDevice(deviceId);
  if (!device || !device.publicKey) {
    throw new functions.https.HttpsError(
      'not-found',
      'Device not registered. Call registerDevice first.'
    );
  }
  
  const tier = device.tier;
  
  // Validate request
  validateTransformRequest(data, tier);
  
  // Verify signature
  const isValid = verifySignature({ deviceId, text, instruction }, signature, device.publicKey);
  if (!isValid) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'Invalid signature'
    );
  }
  
  try {
    // Check rate limit (10/min)
    await checkRateLimit(deviceId, tier);
    
    // Check and increment quota (10/day free, 1000/day pro)
    const quota = await checkAndIncrementQuota(deviceId, tier);
    
    // Transform text via OpenAI
    const result = await transformText(text, instruction);
    
    // Log successful usage
    await logUsage(deviceId, tier, text.length, true);
    
    return { result, quota };
  } catch (error: any) {
    // Log failed usage
    await logUsage(deviceId, tier, text.length, false);
    throw error;
  }
}
