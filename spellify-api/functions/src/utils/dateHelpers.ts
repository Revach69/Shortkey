import * as admin from 'firebase-admin';

export function getTodayString(): string {
  return new Date().toISOString().split('T')[0];
}

export function getNextMidnightISO(): string {
  const tomorrow = new Date();
  tomorrow.setUTCDate(tomorrow.getUTCDate() + 1);
  tomorrow.setUTCHours(0, 0, 0, 0);
  return tomorrow.toISOString();
}

export function getCurrentMinute(): number {
  return Math.floor(Date.now() / 60000);
}

export function getServerTimestamp(): admin.firestore.FieldValue {
  return admin.firestore.FieldValue.serverTimestamp();
}
