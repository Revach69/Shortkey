import * as crypto from 'crypto';
import { SIGNATURE_MAX_AGE_MS } from '../constants';

export function isTimestampValid(timestamp: number): boolean {
  if (typeof timestamp !== 'number' || !Number.isFinite(timestamp)) {
    return false;
  }
  return Math.abs(Date.now() - timestamp) < SIGNATURE_MAX_AGE_MS;
}

export function verifySignature(
  data: Record<string, any>,
  signatureBase64: string,
  publicKeyBase64: string
): boolean {
  try {
    const canonicalRequest = createCanonicalRequest(data);
    
    const publicKey = crypto.createPublicKey({
      key: Buffer.from(publicKeyBase64, 'base64'),
      format: 'der',
      type: 'spki',
    });
    
    const signature = Buffer.from(signatureBase64, 'base64');
    
    return crypto.verify(
      'sha256',
      Buffer.from(canonicalRequest, 'utf8'),
      publicKey,
      signature
    );
  } catch (error) {
    return false;
  }
}

function createCanonicalRequest(data: Record<string, any>): string {
  const sortedKeys = Object.keys(data).sort();
  return JSON.stringify(data, sortedKeys);
}

export function isValidPublicKey(publicKeyBase64: string): boolean {
  try {
    const key = crypto.createPublicKey({
      key: Buffer.from(publicKeyBase64, 'base64'),
      format: 'der',
      type: 'spki',
    });
    return key.asymmetricKeyType === 'ec';
  } catch {
    return false;
  }
}
