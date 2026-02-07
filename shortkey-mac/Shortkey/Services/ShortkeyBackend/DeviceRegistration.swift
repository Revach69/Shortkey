//
//  DeviceRegistration.swift
//  Shortkey
//
//  Handles device registration with backend
//

import Foundation

final class DeviceRegistration {
    
    private let httpClient: BackendHTTPClient
    private let cryptoService: CryptoService
    private let keychainService: KeychainService
    
    init(
        httpClient: BackendHTTPClient,
        cryptoService: CryptoService = .shared,
        keychainService: KeychainService = .shared
    ) {
        self.httpClient = httpClient
        self.cryptoService = cryptoService
        self.keychainService = keychainService
    }
    
    // MARK: - Public Methods
    
    func registerIfNeeded() async throws {
        if UserDefaults.standard.bool(forKey: "deviceRegistered") {
            return
        }
        
        try await register()
    }
    
    func register() async throws {
        let deviceId = keychainService.getOrCreateInstallId()
        let (_, publicKeyData) = try cryptoService.getOrCreateKeyPair()
        let publicKeyBase64 = publicKeyData.base64EncodedString()
        
        let requestBody: [String: Any] = [
            "data": [
                "deviceId": deviceId,
                "publicKey": publicKeyBase64
            ]
        ]
        
        let (_, httpResponse) = try await httpClient.post(
            endpoint: NetworkConstants.ShortkeyApiEndpoint.registerDevice,
            body: requestBody
        )
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw BackendError.registrationFailed
        }
        
        UserDefaults.standard.set(true, forKey: "deviceRegistered")
        AppLogger.log("Device registered successfully")
    }
}
