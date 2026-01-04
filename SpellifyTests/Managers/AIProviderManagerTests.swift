//
//  AIProviderManagerTests.swift
//  SpellifyTests
//
//  Created by Spellify Team on 04/01/2026.
//

import XCTest
@testable import Spellify

final class AIProviderManagerTests: XCTestCase {
    
    var sut: AIProviderManager!
    var mockProvider: MockAIModelProvider!
    var testDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        testDefaults = UserDefaults(suiteName: "AIProviderManagerTests")!
        testDefaults.removePersistentDomain(forName: "AIProviderManagerTests")
        mockProvider = MockAIModelProvider()
        sut = AIProviderManager(provider: mockProvider, defaults: testDefaults)
    }
    
    override func tearDown() {
        testDefaults.removePersistentDomain(forName: "AIProviderManagerTests")
        sut = nil
        mockProvider = nil
        testDefaults = nil
        super.tearDown()
    }
    
    @MainActor
    func test_validateOnLaunch_setsNotConfigured_whenProviderNotConfigured() async {
        mockProvider.isConfigured = false
        
        await sut.validateOnLaunch()
        
        XCTAssertEqual(sut.status, .notConfigured)
    }
    
    @MainActor
    func test_validateOnLaunch_setsConnected_whenTestSucceeds() async {
        mockProvider.isConfigured = true
        mockProvider.testConnectionResult = true
        
        await sut.validateOnLaunch()
        
        if case .connected = sut.status {
            // Success
        } else {
            XCTFail("Expected connected status")
        }
    }
    
    @MainActor
    func test_validateOnLaunch_setsError_whenTestFails() async {
        mockProvider.isConfigured = true
        mockProvider.testConnectionError = OpenAIError.unauthorized
        
        await sut.validateOnLaunch()
        
        if case .error = sut.status {
            // Success
        } else {
            XCTFail("Expected error status")
        }
    }
    
    // MARK: - Transform Tests
    
    func test_transform_throwsTextTooLong_whenTextExceedsLimit() async {
        // Set up connected state
        mockProvider.isConfigured = true
        
        await MainActor.run {
            // Manually set status to connected
            mockProvider.connectionStatus = .connected(model: "gpt-4o")
        }
        
        let longText = String(repeating: "a", count: 10_001)
        let action = SpellAction(name: "Test", prompt: "Test")
        
        do {
            _ = try await sut.transform(text: longText, action: action)
            XCTFail("Should throw textTooLong error")
        } catch let error as SpellifyError {
            XCTAssertEqual(error, .textTooLong)
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }
    
    func test_transform_throwsProviderNotConfigured_whenNotReady() async {
        let action = SpellAction(name: "Test", prompt: "Test")
        
        do {
            _ = try await sut.transform(text: "Hello", action: action)
            XCTFail("Should throw providerNotConfigured error")
        } catch let error as SpellifyError {
            XCTAssertEqual(error, .providerNotConfigured)
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }
    
    // MARK: - Model Selection Tests
    
    func test_selectModel_updatesSelectedModel() {
        let newModel = AIModel(id: "gpt-4o", name: "GPT-4o", provider: "openai")
        
        sut.selectModel(newModel)
        
        XCTAssertEqual(sut.selectedModel.id, "gpt-4o")
    }
    
    func test_selectModel_persistsSelection() {
        let newModel = AIModel(id: "gpt-4o", name: "GPT-4o", provider: "openai")
        
        sut.selectModel(newModel)
        
        // Create new manager with same defaults
        let newManager = AIProviderManager(provider: mockProvider, defaults: testDefaults)
        
        XCTAssertEqual(newManager.selectedModel.id, "gpt-4o")
    }
}

