import * as functions from 'firebase-functions';

jest.mock('../utils/crypto', () => ({
  isValidPublicKey: jest.fn((key: string) => key === 'valid-public-key-base64'),
}));

import { validateRegisterDeviceRequest } from '../handlers/registerDevice/validation';
import { validateTransformRequest } from '../handlers/transformText/validation';
import { Tier } from '../types/models';

describe('validateRegisterDeviceRequest', () => {
  it('should reject missing deviceId', () => {
    expect(() =>
      validateRegisterDeviceRequest({ deviceId: undefined as any, publicKey: 'valid-public-key-base64' })
    ).toThrow(functions.https.HttpsError);
  });

  it('should reject empty deviceId', () => {
    expect(() =>
      validateRegisterDeviceRequest({ deviceId: '', publicKey: 'valid-public-key-base64' })
    ).toThrow(functions.https.HttpsError);
  });

  it('should reject missing publicKey', () => {
    expect(() =>
      validateRegisterDeviceRequest({ deviceId: 'device-123', publicKey: undefined as any })
    ).toThrow(functions.https.HttpsError);
  });

  it('should reject non-string deviceId', () => {
    expect(() =>
      validateRegisterDeviceRequest({ deviceId: 123 as any, publicKey: 'valid-public-key-base64' })
    ).toThrow(functions.https.HttpsError);
  });

  it('should reject non-string publicKey', () => {
    expect(() =>
      validateRegisterDeviceRequest({ deviceId: 'device-123', publicKey: 123 as any })
    ).toThrow(functions.https.HttpsError);
  });

  it('should reject invalid public key format', () => {
    expect(() =>
      validateRegisterDeviceRequest({ deviceId: 'device-123', publicKey: 'invalid-key' })
    ).toThrow(functions.https.HttpsError);
  });

  it('should accept valid deviceId and publicKey', () => {
    expect(() =>
      validateRegisterDeviceRequest({ deviceId: 'device-123', publicKey: 'valid-public-key-base64' })
    ).not.toThrow();
  });
});

describe('validateTransformRequest', () => {
  it('should reject missing text', () => {
    expect(() =>
      validateTransformRequest({ instruction: 'fix grammar' }, Tier.FREE)
    ).toThrow(functions.https.HttpsError);
  });

  it('should reject empty text', () => {
    expect(() =>
      validateTransformRequest({ text: '', instruction: 'fix grammar' }, Tier.FREE)
    ).toThrow(functions.https.HttpsError);
  });

  it('should reject non-string text', () => {
    expect(() =>
      validateTransformRequest({ text: 123, instruction: 'fix grammar' }, Tier.FREE)
    ).toThrow(functions.https.HttpsError);
  });

  it('should reject missing instruction', () => {
    expect(() =>
      validateTransformRequest({ text: 'hello world' }, Tier.FREE)
    ).toThrow(functions.https.HttpsError);
  });

  it('should reject empty instruction', () => {
    expect(() =>
      validateTransformRequest({ text: 'hello world', instruction: '' }, Tier.FREE)
    ).toThrow(functions.https.HttpsError);
  });

  it('should reject text exceeding free tier max length (500)', () => {
    const longText = 'a'.repeat(501);
    expect(() =>
      validateTransformRequest({ text: longText, instruction: 'fix' }, Tier.FREE)
    ).toThrow(functions.https.HttpsError);
  });

  it('should accept text at free tier max length (500)', () => {
    const text = 'a'.repeat(500);
    expect(() =>
      validateTransformRequest({ text, instruction: 'fix' }, Tier.FREE)
    ).not.toThrow();
  });

  it('should reject text exceeding pro tier max length (2000)', () => {
    const longText = 'a'.repeat(2001);
    expect(() =>
      validateTransformRequest({ text: longText, instruction: 'fix' }, Tier.PRO)
    ).toThrow(functions.https.HttpsError);
  });

  it('should accept text at pro tier max length (2000)', () => {
    const text = 'a'.repeat(2000);
    expect(() =>
      validateTransformRequest({ text, instruction: 'fix' }, Tier.PRO)
    ).not.toThrow();
  });

  it('should reject text exceeding byok tier max length (5000)', () => {
    const longText = 'a'.repeat(5001);
    expect(() =>
      validateTransformRequest({ text: longText, instruction: 'fix' }, Tier.BYOK)
    ).toThrow(functions.https.HttpsError);
  });

  it('should accept text at byok tier max length (5000)', () => {
    const text = 'a'.repeat(5000);
    expect(() =>
      validateTransformRequest({ text, instruction: 'fix' }, Tier.BYOK)
    ).not.toThrow();
  });

  it('should accept valid text and instruction', () => {
    expect(() =>
      validateTransformRequest({ text: 'hello world', instruction: 'fix grammar' }, Tier.FREE)
    ).not.toThrow();
  });
});
