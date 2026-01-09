//
//  BackendHTTPClient.swift
//  Spellify
//
//  HTTP client for backend API communication
//

import Foundation

final class BackendHTTPClient {
    
    private let baseURL: String
    private let session: URLSession
    
    init(
        baseURL: String = NetworkConstants.spellifyApiBaseURL,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }
    
    // MARK: - Public Methods
    
    func post(
        endpoint: String,
        body: [String: Any]
    ) async throws -> (Data, HTTPURLResponse) {
        let url = URL(string: "\(baseURL)/\(endpoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BackendError.invalidResponse
        }
        
        return (data, httpResponse)
    }
}
