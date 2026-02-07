import * as admin from 'firebase-admin';

export function getTodayString(): string {
  return new Date().toISOString().split('T')[0];
}

export function getCurrentMonthString(): string {
  return new Date().toISOString().slice(0, 7);
}

export function getNextMidnightISO(): string {
  const tomorrow = new Date();
  tomorrow.setUTCDate(tomorrow.getUTCDate() + 1);
  tomorrow.setUTCHours(0, 0, 0, 0);
  return tomorrow.toISOString();
}

export function getNextMonthFirstDayISO(): string {
  const now = new Date();
  const nextMonth = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() + 1, 1));
  return nextMonth.toISOString();
}

export function getCurrentMinute(): number {
  return Math.floor(Date.now() / 60000);
}

export function getServerTimestamp(): admin.firestore.FieldValue {
  return admin.firestore.FieldValue.serverTimestamp();
}
