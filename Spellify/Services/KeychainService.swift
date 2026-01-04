//
//  KeychainService.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation
import Security

/// Service for securely storing and retrieving sensitive data in the Keychain
final class KeychainService: KeychainServiceProtocol {
    
    // MARK: - Properties
    
    private let service: String
    
    // MARK: - Initialization
    
    init(service: String = "com.spellify.keychain") {
        self.service = service
    }
    
    // MARK: - Public Methods
    
    /// Saves a value to the Keychain
    func save(key: String, value: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.encodingFailed
        }
        
        // Delete existing item first
        try? delete(key: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status: status)
        }
    }
    
    /// Retrieves a value from the Keychain
    func retrieve(key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        switch status {
        case errSecSuccess:
            guard let data = result as? Data,
                  let value = String(data: data, encoding: .utf8) else {
                throw KeychainError.decodingFailed
            }
            return value
            
        case errSecItemNotFound:
            return nil
            
        default:
            throw KeychainError.retrieveFailed(status: status)
        }
    }
    
    /// Deletes a value from the Keychain
    func delete(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status: status)
        }
    }
}

// MARK: - Errors

enum KeychainError: LocalizedError {
    case encodingFailed
    case decodingFailed
    case saveFailed(status: OSStatus)
    case retrieveFailed(status: OSStatus)
    case deleteFailed(status: OSStatus)
    
    var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return "Failed to encode data"
        case .decodingFailed:
            return "Failed to decode data"
        case .saveFailed(let status):
            return "Failed to save to Keychain: \(status)"
        case .retrieveFailed(let status):
            return "Failed to retrieve from Keychain: \(status)"
        case .deleteFailed(let status):
            return "Failed to delete from Keychain: \(status)"
        }
    }
}


