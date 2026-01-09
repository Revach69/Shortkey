//
//  SpellifyBackendService.swift
//  Spellify
//
//  Main service for Spellify backend integration
//

import Foundation

/// Service for communicating with Spellify backend
final class SpellifyBackendService {
    
    // MARK: - Singleton
    
    static let shared = SpellifyBackendService()
    
    // MARK: - Dependencies
    
    private let deviceRegistration: DeviceRegistration
    private let textTransformer: TextTransformer
    
    // MARK: - Initialization
    
    private init(
        httpClient: BackendHTTPClient = BackendHTTPClient()
    ) {
        self.deviceRegistration = DeviceRegistration(httpClient: httpClient)
        self.textTransformer = TextTransformer(httpClient: httpClient)
    }
    
    // MARK: - Public API
    
    /// Register device with backend (one-time operation)
    func registerDeviceIfNeeded() async throws {
        try await deviceRegistration.registerIfNeeded()
    }
    
    /// Transform text using backend AI
    func transformText(
        _ text: String,
        instruction: String
    ) async throws -> (result: String, quota: QuotaInfo) {
        try await textTransformer.transform(text: text, instruction: instruction)
    }
}
