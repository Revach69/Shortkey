import * as crypto from 'crypto';
import { verifySignature, isValidPublicKey } from '../utils/crypto';

function generateTestKeyPair() {
  const { publicKey, privateKey } = crypto.generateKeyPairSync('ec', {
    namedCurve: 'P-256',
  });

  const publicKeyDer = publicKey.export({ format: 'der', type: 'spki' });
  const publicKeyBase64 = publicKeyDer.toString('base64');

  return { publicKey, privateKey, publicKeyBase64 };
}

function signData(data: Record<string, any>, privateKey: crypto.KeyObject): string {
  const sortedKeys = Object.keys(data).sort();
  const canonical = JSON.stringify(data, sortedKeys);
  const signature = crypto.sign('sha256', Buffer.from(canonical, 'utf8'), privateKey);
  return signature.toString('base64');
}

describe('verifySignature', () => {
  it('should verify a valid signature', () => {
    const { privateKey, publicKeyBase64 } = generateTestKeyPair();
    const data = { text: 'hello', instruction: 'fix grammar' };
    const signature = signData(data, privateKey);

    expect(verifySignature(data, signature, publicKeyBase64)).toBe(true);
  });

  it('should reject tampered data', () => {
    const { privateKey, publicKeyBase64 } = generateTestKeyPair();
    const data = { text: 'hello', instruction: 'fix grammar' };
    const signature = signData(data, privateKey);

    const tamperedData = { text: 'goodbye', instruction: 'fix grammar' };
    expect(verifySignature(tamperedData, signature, publicKeyBase64)).toBe(false);
  });

  it('should reject signature from wrong key', () => {
    const keyPair1 = generateTestKeyPair();
    const keyPair2 = generateTestKeyPair();
    const data = { text: 'hello', instruction: 'fix' };
    const signature = signData(data, keyPair1.privateKey);

    expect(verifySignature(data, signature, keyPair2.publicKeyBase64)).toBe(false);
  });

  it('should return false for invalid signature format', () => {
    const { publicKeyBase64 } = generateTestKeyPair();
    const data = { text: 'hello' };

    expect(verifySignature(data, 'not-a-valid-signature', publicKeyBase64)).toBe(false);
  });

  it('should return false for invalid public key', () => {
    const data = { text: 'hello' };
    expect(verifySignature(data, 'signature', 'invalid-key')).toBe(false);
  });
});

describe('isValidPublicKey', () => {
  it('should accept a valid EC public key', () => {
    const { publicKeyBase64 } = generateTestKeyPair();
    expect(isValidPublicKey(publicKeyBase64)).toBe(true);
  });

  it('should reject an invalid base64 string', () => {
    expect(isValidPublicKey('not-a-valid-key')).toBe(false);
  });

  it('should reject an empty string', () => {
    expect(isValidPublicKey('')).toBe(false);
  });

  it('should reject a non-EC key (RSA)', () => {
    const { publicKey } = crypto.generateKeyPairSync('rsa', {
      modulusLength: 2048,
    });
    const rsaKeyBase64 = publicKey
      .export({ format: 'der', type: 'spki' })
      .toString('base64');

    expect(isValidPublicKey(rsaKeyBase64)).toBe(false);
  });
});
