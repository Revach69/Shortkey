import { onCall } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import * as admin from 'firebase-admin';
import { registerDeviceHandler, RegisterDeviceRequest } from './handlers/registerDevice';
import { transformTextHandler } from './handlers/transformText';
import { withRequestContext } from './utils/withRequestContext/withRequestContext';
import { SECRETS } from './constants';

admin.initializeApp();

const openaiApiKey = defineSecret(SECRETS.OPENAI_API_KEY);

export const registerDevice = onCall<RegisterDeviceRequest>(
  (request) => {
    const clientIp = request.rawRequest?.ip ||
      (request.rawRequest?.headers['x-forwarded-for'] as string | undefined);
    return registerDeviceHandler(request.data, clientIp);
  }
);

export const transformText = onCall({
  timeoutSeconds: 30,
  memory: '256MiB',
  secrets: [openaiApiKey],
}, withRequestContext(transformTextHandler));
