import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { registerDeviceHandler, RegisterDeviceRequest } from './handlers/registerDevice';
import { transformTextHandler } from './handlers/transformText';
import { withRequestContext } from './utils/withRequestContext/withRequestContext';

admin.initializeApp();

export const registerDevice = functions
  .https.onCall((request: functions.https.CallableRequest<RegisterDeviceRequest>) => 
    registerDeviceHandler(request.data)
  );

export const transformText = functions
  .runWith({
    timeoutSeconds: 30,
    memory: '256MB',
  })
  .https.onCall(withRequestContext(transformTextHandler));
