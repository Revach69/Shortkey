export const Tier = {
    FREE: 'free',
    PRO: 'pro',
    BYOK: 'byok',
  } as const;

  export type TierType = typeof Tier[keyof typeof Tier];

  export interface QuotaInfo {
    used: number;
    limit: number;
    resetsAt: string;
  }

  export interface Device {
    deviceId: string;
    publicKey: string;
    tier: TierType;
    monthlyCount: number;
    lastReset: string;
    firstSeen: any;
    lastSeen: any;
  }
  