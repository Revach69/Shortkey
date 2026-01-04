//
//  OpenAIProviderTests.swift
//  SpellifyTests
//
//  Created by Spellify Team on 04/01/2026.
//

import XCTest
@testable import Spellify

final class OpenAIProviderTests: XCTestCase {
    
    var sut: OpenAIProvider!
    var mockSession: MockURLSession!
    var mockKeychain: MockKeychainService!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        mockKeychain = MockKeychainService()
        sut = OpenAIProvider(session: mockSession, keychain: mockKeychain)
    }
    
    override func tearDown() {
        sut = nil
        mockSession = nil
        mockKeychain = nil
        super.tearDown()
    }
    
    // MARK: - isConfigured Tests
    
    func test_isConfigured_returnsFalse_whenNoAPIKey() {
        XCTAssertFalse(sut.isConfigured)
    }
    
    func test_isConfigured_returnsTrue_whenAPIKeyExists() {
        mockKeychain.setStoredValue("sk-test-key", forKey: "openai-api-key")
        
        XCTAssertTrue(sut.isConfigured)
    }
    
    // MARK: - Configure Tests
    
    func test_configure_savesAPIKeyToKeychain() async {
        await sut.configure(apiKey: "sk-new-key")
        
        XCTAssertEqual(mockKeychain.saveCallCount, 1)
        XCTAssertEqual(try? mockKeychain.retrieve(key: "openai-api-key"), "sk-new-key")
    }
    
    // MARK: - Test Connection Tests
    
    func test_testConnection_throwsNoAPIKey_whenNotConfigured() async {
        do {
            _ = try await sut.testConnection()
            XCTFail("Should throw noAPIKey error")
        } catch let error as OpenAIError {
            XCTAssertEqual(error, .noAPIKey)
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }
    
    func test_testConnection_returnsTrue_whenResponseIs200() async throws {
        mockKeychain.setStoredValue("sk-valid-key", forKey: "openai-api-key")
        mockSession.setSuccessResponse(MockResponses.modelsSuccess)
        
        let result = try await sut.testConnection()
        
        XCTAssertTrue(result)
        XCTAssertEqual(mockSession.requestCount, 1)
    }
    
    func test_testConnection_throwsUnauthorized_whenResponseIs401() async {
        mockKeychain.setStoredValue("sk-invalid-key", forKey: "openai-api-key")
        mockSession.setErrorResponse(statusCode: 401)
        
        do {
            _ = try await sut.testConnection()
            XCTFail("Should throw unauthorized error")
        } catch let error as OpenAIError {
            XCTAssertEqual(error, .unauthorized)
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }
    
    // MARK: - Fetch Models Tests
    
    func test_fetchModels_parsesModelsCorrectly() async throws {
        mockKeychain.setStoredValue("sk-test-key", forKey: "openai-api-key")
        mockSession.setSuccessResponse(MockResponses.modelsSuccess)
        
        let models = try await sut.fetchAvailableModels()
        
        XCTAssertFalse(models.isEmpty)
        XCTAssertTrue(models.contains(where: { $0.id == "gpt-4o-mini" }))
        XCTAssertTrue(models.contains(where: { $0.id == "gpt-4o" }))
    }
    
    // MARK: - Transform Tests
    
    func test_transform_sendsCorrectRequest() async throws {
        mockKeychain.setStoredValue("sk-test-key", forKey: "openai-api-key")
        mockSession.setSuccessResponse(MockResponses.transformSuccess("Fixed text"))
        
        let result = try await sut.transform(
            text: "hello wrold",
            prompt: "Fix grammar",
            model: "gpt-4o-mini"
        )
        
        XCTAssertEqual(result, "Fixed text")
        XCTAssertEqual(mockSession.requestCount, 1)
        XCTAssertEqual(mockSession.lastRequest?.httpMethod, "POST")
        XCTAssertTrue(mockSession.lastRequestBody.contains("hello wrold"))
        XCTAssertTrue(mockSession.lastRequestBody.contains("Fix grammar"))
        XCTAssertTrue(mockSession.lastRequestBody.contains("gpt-4o-mini"))
    }
    
    func test_transform_throwsNoAPIKey_whenNotConfigured() async {
        do {
            _ = try await sut.transform(text: "test", prompt: "test", model: "gpt-4o-mini")
            XCTFail("Should throw noAPIKey error")
        } catch let error as OpenAIError {
            XCTAssertEqual(error, .noAPIKey)
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }
    
    func test_transform_trimsWhitespace_fromResponse() async throws {
        mockKeychain.setStoredValue("sk-test-key", forKey: "openai-api-key")
        mockSession.setSuccessResponse(MockResponses.transformSuccess("  Fixed text  \n"))
        
        let result = try await sut.transform(text: "test", prompt: "test", model: "gpt-4o-mini")
        
        XCTAssertEqual(result, "Fixed text")
    }
}

// MARK: - OpenAIError Equatable

extension OpenAIError: Equatable {
    public static func == (lhs: OpenAIError, rhs: OpenAIError) -> Bool {
        switch (lhs, rhs) {
        case (.noAPIKey, .noAPIKey),
             (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse),
             (.unauthorized, .unauthorized),
             (.noContent, .noContent):
            return true
        case (.httpError(let lCode), .httpError(let rCode)):
            return lCode == rCode
        default:
            return false
        }
    }
}


