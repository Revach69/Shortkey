import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { registerDeviceHandler } from './handlers/registerDevice';
import { transformHandler } from './handlers/transform';

// Initialize Firebase Admin
admin.initializeApp();

// Export Cloud Functions
export const registerDevice = functions
  .https.onCall(registerDeviceHandler);

export const transform = functions
  .runWith({
    timeoutSeconds: 30,
    memory: '256MB',
  })
  .https.onCall(transformHandler);
