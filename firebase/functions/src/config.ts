import { Tier } from './types';

export const CONFIG = {
  tiers: {
    [Tier.FREE]: {
      daily: 10,
      burst: 10,
      maxTextLength: 500,
    },
    [Tier.PRO]: {
      daily: 1000,
      burst: 10,
      maxTextLength: 2000,
    },
  },
  openai: {
    model: 'gpt-4o-mini',
    temperature: 0.3,
    maxTokens: 4096,
  },
} as const;
