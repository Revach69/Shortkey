export const Tier = {
  FREE: 'free',
  PRO: 'pro',
} as const;

export type TierType = typeof Tier[keyof typeof Tier];

export interface RegisterDeviceRequest {
  deviceId: string;
  publicKey: string;
}

export interface TransformRequest {
  deviceId: string;
  text: string;
  instruction: string;
  signature: string;
}

export interface TransformResponse {
  result: string;
  quota: QuotaInfo;
}

export interface QuotaInfo {
  used: number;
  limit: number;
  resetsAt: string;
}
