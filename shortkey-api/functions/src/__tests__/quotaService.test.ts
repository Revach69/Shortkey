import * as functions from 'firebase-functions';

const mockGet = jest.fn();
const mockSet = jest.fn();
const mockRunTransaction = jest.fn();
const mockDoc = jest.fn();
const mockCollection = jest.fn(() => ({ doc: mockDoc }));

jest.mock('firebase-admin', () => ({
  firestore: Object.assign(
    () => ({
      collection: mockCollection,
      runTransaction: mockRunTransaction,
    }),
    {
      FieldValue: {
        serverTimestamp: () => 'SERVER_TIMESTAMP',
      },
    }
  ),
}));

jest.mock('../utils/dateHelpers', () => ({
  getCurrentMonthString: jest.fn(() => '2026-02'),
  getNextMonthFirstDayISO: jest.fn(() => '2026-03-01T00:00:00.000Z'),
  getServerTimestamp: jest.fn(() => 'SERVER_TIMESTAMP'),
}));

import { checkAndIncrementQuota } from '../services/quotaService';
import { Tier } from '../types/models';

beforeEach(() => {
  jest.clearAllMocks();
  mockDoc.mockReturnValue('deviceRef');
  mockRunTransaction.mockImplementation(async (callback: any) => {
    const transaction = { get: mockGet, set: mockSet };
    return callback(transaction);
  });
});

describe('checkAndIncrementQuota', () => {
  describe('monthly reset logic', () => {
    it('should reset count when month changes', async () => {
      mockGet.mockResolvedValue({
        exists: true,
        data: () => ({ monthlyCount: 5, lastReset: '2026-01' }),
      });

      const result = await checkAndIncrementQuota('device-1', Tier.FREE);

      expect(mockSet).toHaveBeenCalledWith(
        'deviceRef',
        expect.objectContaining({ monthlyCount: 1, lastReset: '2026-02' })
      );
      expect(result.used).toBe(1);
    });

    it('should NOT reset count within same month', async () => {
      mockGet.mockResolvedValue({
        exists: true,
        data: () => ({ monthlyCount: 3, lastReset: '2026-02' }),
      });

      const result = await checkAndIncrementQuota('device-1', Tier.FREE);

      expect(mockSet).toHaveBeenCalledWith(
        'deviceRef',
        expect.objectContaining({ monthlyCount: 4, lastReset: '2026-02' })
      );
      expect(result.used).toBe(4);
    });

    it('should increment count after check', async () => {
      mockGet.mockResolvedValue({
        exists: true,
        data: () => ({ monthlyCount: 0, lastReset: '2026-02' }),
      });

      const result = await checkAndIncrementQuota('device-1', Tier.FREE);

      expect(result.used).toBe(1);
      expect(result.limit).toBe(50);
    });
  });

  describe('quota limits', () => {
    it('should allow request when under limit', async () => {
      mockGet.mockResolvedValue({
        exists: true,
        data: () => ({ monthlyCount: 5, lastReset: '2026-02' }),
      });

      const result = await checkAndIncrementQuota('device-1', Tier.FREE);

      expect(result.used).toBe(6);
      expect(result.limit).toBe(50);
      expect(result.resetsAt).toBe('2026-03-01T00:00:00.000Z');
    });

    it('should reject request when at limit (free tier, limit=50)', async () => {
      mockGet.mockResolvedValue({
        exists: true,
        data: () => ({ monthlyCount: 50, lastReset: '2026-02' }),
      });

      await expect(
        checkAndIncrementQuota('device-1', Tier.FREE)
      ).rejects.toThrow(functions.https.HttpsError);
    });

    it('should use correct limit for pro tier (2000)', async () => {
      mockGet.mockResolvedValue({
        exists: true,
        data: () => ({ monthlyCount: 1999, lastReset: '2026-02' }),
      });

      const result = await checkAndIncrementQuota('device-1', Tier.PRO);

      expect(result.used).toBe(2000);
      expect(result.limit).toBe(2000);
    });

    it('should reject pro tier when at limit (2000)', async () => {
      mockGet.mockResolvedValue({
        exists: true,
        data: () => ({ monthlyCount: 2000, lastReset: '2026-02' }),
      });

      await expect(
        checkAndIncrementQuota('device-1', Tier.PRO)
      ).rejects.toThrow(functions.https.HttpsError);
    });

    it('should use correct limit for byok tier (99999)', async () => {
      mockGet.mockResolvedValue({
        exists: true,
        data: () => ({ monthlyCount: 100, lastReset: '2026-02' }),
      });

      const result = await checkAndIncrementQuota('device-1', Tier.BYOK);

      expect(result.used).toBe(101);
      expect(result.limit).toBe(99999);
    });
  });

  describe('error handling', () => {
    it('should throw not-found for unregistered device', async () => {
      mockGet.mockResolvedValue({ exists: false });

      await expect(
        checkAndIncrementQuota('unknown-device', Tier.FREE)
      ).rejects.toThrow(functions.https.HttpsError);
    });
  });
});
