export const COLLECTIONS = {
  DEVICES: 'devices',
  RATE_LIMITS: 'rateLimits',
  REGISTRATION_RATE_LIMITS: 'registrationRateLimits',
} as const;

export const SECRETS = {
  OPENAI_API_KEY: 'OPENAI_API_KEY',
} as const;

export const SIGNATURE_MAX_AGE_MS = 5 * 60 * 1000; // 5 minutes
export const REGISTER_RATE_LIMIT_PER_HOUR = 5;