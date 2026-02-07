//
//  CryptoService.swift
//  Shortkey
//
//  Crypto signing service for request authentication
//

import Foundation
import CryptoKit

class CryptoService {
    static let shared = CryptoService()
    private let keychainService = KeychainService.shared
    
    private init() {}
    
    func getOrCreateKeyPair() throws -> (privateKey: P256.Signing.PrivateKey, publicKey: Data) {
        if let existingKey = try? loadPrivateKey() {
            let publicKeyData = existingKey.publicKey.x963Representation
            return (existingKey, publicKeyData)
        }
        
        let privateKey = P256.Signing.PrivateKey()
        try savePrivateKey(privateKey)
        
        let publicKeyData = privateKey.publicKey.x963Representation
        return (privateKey, publicKeyData)
    }
    
    private func savePrivateKey(_ key: P256.Signing.PrivateKey) throws {
        let keyData = key.rawRepresentation
        let keyBase64 = keyData.base64EncodedString()
        try keychainService.save(key: AppConstants.privateKeyTag, value: keyBase64)
    }
    
    private func loadPrivateKey() throws -> P256.Signing.PrivateKey {
        guard let keyBase64 = try keychainService.retrieve(key: AppConstants.privateKeyTag),
              let keyData = Data(base64Encoded: keyBase64) else {
            throw CryptoError.keyNotFound
        }
        return try P256.Signing.PrivateKey(rawRepresentation: keyData)
    }
    
    func sign(deviceId: String, text: String, instruction: String) throws -> String {
        let privateKey = try loadPrivateKey()
        
        let data: [String: String] = [
            "deviceId": deviceId,
            "text": text,
            "instruction": instruction
        ]
        let sortedKeys = data.keys.sorted()
        let canonicalDict = sortedKeys.reduce(into: [String: String]()) { $0[$1] = data[$1] }
        let jsonData = try JSONSerialization.data(withJSONObject: canonicalDict)
        
        let signature = try privateKey.signature(for: jsonData)
        return signature.derRepresentation.base64EncodedString()
    }
}

// MARK: - Errors

enum CryptoError: LocalizedError {
    case keyNotFound
    case invalidKeyData
    
    var errorDescription: String? {
        switch self {
        case .keyNotFound:
            return "Private key not found in Keychain"
        case .invalidKeyData:
            return "Invalid key data"
        }
    }
}
