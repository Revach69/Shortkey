import { validateRegisterDeviceRequest } from './validation';
import { createDevice } from '../../services/collections/deviceCollection';
import { getServerTimestamp, getTodayString } from '../../utils/dateHelpers';
import { Tier } from '../../types/models';

export interface RegisterDeviceRequest {
  deviceId: string;
  publicKey: string;
}

export async function registerDeviceHandler(
  data: RegisterDeviceRequest
): Promise<{ success: boolean }> {
  validateRegisterDeviceRequest(data);
  
  const now = getServerTimestamp();
  const today = getTodayString();

  await createDevice(data.deviceId, data.publicKey, Tier.FREE, 0, today, now);
  
  return { success: true };
}
