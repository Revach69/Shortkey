//
//  TextTransformer.swift
//  Spellify
//
//  Handles text transformation via backend
//

import Foundation

final class TextTransformer {
    
    private let httpClient: BackendHTTPClient
    private let cryptoService: CryptoService
    private let keychainService: KeychainService
    private let responseParser: ResponseParser
    
    init(
        httpClient: BackendHTTPClient,
        cryptoService: CryptoService = .shared,
        keychainService: KeychainService = .shared,
        responseParser: ResponseParser = ResponseParser()
    ) {
        self.httpClient = httpClient
        self.cryptoService = cryptoService
        self.keychainService = keychainService
        self.responseParser = responseParser
    }
    
    // MARK: - Public Methods
    
    func transform(
        text: String,
        instruction: String
    ) async throws -> (result: String, quota: QuotaInfo) {
        let deviceId = keychainService.getOrCreateInstallId()
        
        let signature = try cryptoService.sign(
            deviceId: deviceId,
            text: text,
            instruction: instruction
        )
        
        let requestBody: [String: Any] = [
            "data": [
                "deviceId": deviceId,
                "text": text,
                "instruction": instruction,
                "signature": signature
            ]
        ]
        
        let (data, httpResponse) = try await httpClient.post(
            endpoint: "transform",
            body: requestBody
        )
        
        try responseParser.validateResponse(httpResponse)
        
        let result = try responseParser.parseTransformResponse(data)
        
        AppLogger.log("Transform successful. Quota: \(result.quota.used)/\(result.quota.limit)")
        
        return result
    }
}
