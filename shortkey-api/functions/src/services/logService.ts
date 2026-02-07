import * as functions from 'firebase-functions';
import { TierType } from '../types/models';
import { CONFIG } from '../config';

/**
 * Logs usage events to Cloud Logging (structured logs)
 * 
 * These logs can be:
 * - Viewed in Cloud Console (Logging)
 * - Queried with filters (e.g., jsonPayload.success=false)
 * - Exported to BigQuery for analytics
 * - Used for monitoring/alerting
 */
export function logUsage(
  deviceId: string,
  tier: TierType,
  textLength: number,
  success: boolean
): void {
  functions.logger.log('usage_event', {
    deviceId,
    tier,
    textLength,
    success,
    model: CONFIG.openai.model,
    timestamp: new Date().toISOString(),
  });
}
