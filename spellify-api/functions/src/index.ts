import * as functions from 'firebase-functions';
import { defineSecret } from 'firebase-functions/params';
import * as admin from 'firebase-admin';
import { registerDeviceHandler, RegisterDeviceRequest } from './handlers/registerDevice';
import { transformTextHandler } from './handlers/transformText';
import { withRequestContext } from './utils/withRequestContext/withRequestContext';
import { SECRETS } from './constants';

admin.initializeApp();

const openaiApiKey = defineSecret(SECRETS.OPENAI_API_KEY);

export const registerDevice = functions
  .https.onCall((request: functions.https.CallableRequest<RegisterDeviceRequest>) => 
    registerDeviceHandler(request.data)
  );

export const transformText = functions
  .runWith({
    timeoutSeconds: 30,
    memory: '256MB',
    secrets: [openaiApiKey],
  })
  .https.onCall(withRequestContext(transformTextHandler));
