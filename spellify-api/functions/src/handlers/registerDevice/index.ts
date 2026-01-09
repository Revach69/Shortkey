import * as functions from 'firebase-functions';
import { RegisterDeviceRequest } from '../../types';
import { validateRegisterDeviceRequest } from './validation';
import { registerDevice as registerDeviceService } from '../../services/deviceCollection';

/**
 * Handler for device registration
 * Validates request and registers device with public key
 */
export async function registerDeviceHandler(
  request: functions.https.CallableRequest<RegisterDeviceRequest>
): Promise<{ success: boolean }> {
  const data = request.data;
  
  // Validate input
  validateRegisterDeviceRequest(data);
  
  // Register device
  await registerDeviceService(data.deviceId, data.publicKey);
  
  return { success: true };
}
