import * as crypto from 'crypto';

export function verifySignature(
  data: { deviceId: string; text: string; instruction: string },
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

export function createCanonicalRequest(data: {
  deviceId: string;
  text: string;
  instruction: string;
}): string {
  return JSON.stringify(data, ['deviceId', 'text', 'instruction'].sort());
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
