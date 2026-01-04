//
//  MockKeychainService.swift
//  SpellifyTests
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation
@testable import Spellify

/// Mock implementation of KeychainService for testing
final class MockKeychainService: KeychainServiceProtocol {
    
    // MARK: - Storage
    
    private var storage: [String: String] = [:]
    
    // MARK: - Test Control Properties
    
    var saveError: Error?
    var retrieveError: Error?
    var deleteError: Error?
    
    var saveCallCount = 0
    var retrieveCallCount = 0
    var deleteCallCount = 0
    
    // MARK: - KeychainServiceProtocol Methods
    
    func save(key: String, value: String) throws {
        saveCallCount += 1
        if let error = saveError {
            throw error
        }
        storage[key] = value
    }
    
    func retrieve(key: String) throws -> String? {
        retrieveCallCount += 1
        if let error = retrieveError {
            throw error
        }
        return storage[key]
    }
    
    func delete(key: String) throws {
        deleteCallCount += 1
        if let error = deleteError {
            throw error
        }
        storage.removeValue(forKey: key)
    }
    
    // MARK: - Test Helpers
    
    func reset() {
        storage.removeAll()
        saveError = nil
        retrieveError = nil
        deleteError = nil
        saveCallCount = 0
        retrieveCallCount = 0
        deleteCallCount = 0
    }
    
    /// Pre-populate storage for testing
    func setStoredValue(_ value: String, forKey key: String) {
        storage[key] = value
    }
}


