export const Tier = {
    FREE: 'free',
    PRO: 'pro',
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
    dailyCount: number;
    lastReset: string;
    firstSeen: any;
    lastSeen: any;
  }
  