//
//  MockURLSession.swift
//  SpellifyTests
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation
@testable import Spellify

/// Mock implementation of URLSession for testing
final class MockURLSession: URLSessionProtocol {
    
    // MARK: - Test Control Properties
    
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    var lastRequest: URLRequest?
    var lastRequestBody: String = ""
    var requestCount = 0
    
    // MARK: - URLSessionProtocol Methods
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        requestCount += 1
        lastRequest = request
        
        if let body = request.httpBody {
            lastRequestBody = String(data: body, encoding: .utf8) ?? ""
        }
        
        if let error = mockError {
            throw error
        }
        
        let data = mockData ?? Data()
        let response = mockResponse ?? HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        return (data, response)
    }
    
    // MARK: - Test Helpers
    
    func reset() {
        mockData = nil
        mockResponse = nil
        mockError = nil
        lastRequest = nil
        lastRequestBody = ""
        requestCount = 0
    }
    
    /// Sets up a successful response with the given data
    func setSuccessResponse(_ data: Data, statusCode: Int = 200) {
        mockData = data
        mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.openai.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
    }
    
    /// Sets up an error response
    func setErrorResponse(statusCode: Int) {
        mockData = Data()
        mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.openai.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
    }
}

// MARK: - Mock Response Data

enum MockResponses {
    
    static let modelsSuccess = """
    {
        "data": [
            {"id": "gpt-4o-mini", "object": "model"},
            {"id": "gpt-4o", "object": "model"},
            {"id": "gpt-3.5-turbo", "object": "model"}
        ]
    }
    """.data(using: .utf8)!
    
    static func transformSuccess(_ text: String) -> Data {
        """
        {
            "id": "chatcmpl-123",
            "choices": [
                {
                    "index": 0,
                    "message": {"role": "assistant", "content": "\(text)"},
                    "finish_reason": "stop"
                }
            ],
            "usage": {
                "prompt_tokens": 10,
                "completion_tokens": 20,
                "total_tokens": 30
            }
        }
        """.data(using: .utf8)!
    }
}


