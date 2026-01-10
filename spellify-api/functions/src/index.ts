import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { registerDeviceHandler } from './handlers/registerDevice';
import { transformTextHandler } from './handlers/transformText';

admin.initializeApp();

export const registerDevice = functions
  .https.onCall(registerDeviceHandler);

export const transformText = functions
  .runWith({
    timeoutSeconds: 30,
    memory: '256MB',
  })
  .https.onCall(transformTextHandler);
