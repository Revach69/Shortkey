//
//  MockAIModelProvider.swift
//  SpellifyTests
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation
@testable import Spellify

/// Mock implementation of AIModelProvider for testing
final class MockAIModelProvider: AIModelProvider {
    
    // MARK: - AIModelProvider Properties
    
    let id = "mock"
    let displayName = "Mock Provider"
    
    var isConfigured: Bool = false
    var connectionStatus: ConnectionStatus = .notConfigured
    
    // MARK: - Test Control Properties
    
    var testConnectionResult: Bool = true
    var testConnectionError: Error?
    var transformResult: String = "Transformed text"
    var transformError: Error?
    var availableModels: [AIModel] = [
        AIModel(id: "mock-model", name: "Mock Model", provider: "mock")
    ]
    
    var configureCallCount = 0
    var testConnectionCallCount = 0
    var transformCallCount = 0
    var lastTransformText: String?
    var lastTransformPrompt: String?
    var lastTransformModel: String?
    
    // MARK: - AIModelProvider Methods
    
    func configure(apiKey: String) async {
        configureCallCount += 1
        isConfigured = true
    }
    
    func testConnection() async throws -> Bool {
        testConnectionCallCount += 1
        if let error = testConnectionError {
            throw error
        }
        return testConnectionResult
    }
    
    func fetchAvailableModels() async throws -> [AIModel] {
        return availableModels
    }
    
    func transform(text: String, prompt: String, model: String) async throws -> String {
        transformCallCount += 1
        lastTransformText = text
        lastTransformPrompt = prompt
        lastTransformModel = model
        
        if let error = transformError {
            throw error
        }
        return transformResult
    }
    
    // MARK: - Test Helpers
    
    func reset() {
        isConfigured = false
        connectionStatus = .notConfigured
        testConnectionResult = true
        testConnectionError = nil
        transformResult = "Transformed text"
        transformError = nil
        configureCallCount = 0
        testConnectionCallCount = 0
        transformCallCount = 0
        lastTransformText = nil
        lastTransformPrompt = nil
        lastTransformModel = nil
    }
}



