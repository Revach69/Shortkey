import { QuotaInfo } from '../../types/models';
import { validateTransformRequest } from './validation';
import { getRequestContext } from '../../utils/getRequestContext';
import { checkAndIncrementQuota } from '../../services/quotaService';
import { transformText } from '../../services/externals/openAiApi';
import { logUsage } from '../../services/logService';

interface TransformRequest {
  deviceId: string;
  text: string;
  instruction: string;
  signature: string;
}

interface TransformResponse {
  result: string;
  quota: QuotaInfo;
}

/**
 * Handler for text transformation
 * Validates signature, checks limits, transforms text via OpenAI
 */
export async function transformTextHandler(data: TransformRequest): Promise<TransformResponse> {
  const { deviceId, text, instruction, signature } = data;
  
  const { device } = await getRequestContext(deviceId, signature, { deviceId, text, instruction });
  validateTransformRequest(data, device.tier);
  
  const quota = await checkAndIncrementQuota(device.deviceId, device.tier);
  
  try {
    const result = await transformText(text, instruction);
    logUsage(device.deviceId, device.tier, text.length, true);
    return { result, quota };
  } catch (error: any) {
    logUsage(device.deviceId, device.tier, text.length, false);
    throw error;
  }
}
