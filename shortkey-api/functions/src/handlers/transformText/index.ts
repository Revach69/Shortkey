import { QuotaInfo } from '../../types/models';
import { RequestContext } from '../../types/server';
import { validateTransformRequest } from './validation';
import { checkAndIncrementQuota } from '../../services/quotaService';
import { transformText } from '../../services/externals/openAiApi';
import { logUsage } from '../../services/logService';

interface TransformRequest {
  deviceId: string;
  text: string;
  instruction: string;
  signature: string;
  timestamp: number;
}

interface TransformResponse {
  result: string;
  quota: QuotaInfo;
}

/**
 * Handler for text transformation
 * Validates request, checks limits, transforms text via OpenAI
 */
export async function transformTextHandler(
  data: TransformRequest,
  context: RequestContext
): Promise<TransformResponse> {
  const { text, instruction } = data;
  const { device } = context;
  
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
