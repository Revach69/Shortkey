import { Tier } from './types/models';

export const CONFIG = {
  tiers: {
    [Tier.FREE]: {
      monthly: 50,
      burst: 10,
      maxTextLength: 500,
    },
    [Tier.PRO]: {
      monthly: 2000,
      burst: 10,
      maxTextLength: 2000,
    },
    [Tier.BYOK]: {
      monthly: 99999,
      burst: 20,
      maxTextLength: 5000,
    },
  },
  openai: {
    model: 'gpt-4o-mini',
    temperature: 0.3,
    maxTokens: 4096,
  },
} as const;
