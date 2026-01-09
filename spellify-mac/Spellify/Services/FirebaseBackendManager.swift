//
//  FirebaseBackendManager.swift
//  Spellify
//
//  Firebase backend integration for text transformation
//

import Foundation

final class FirebaseBackendManager {
    static let shared = FirebaseBackendManager()
    
    private let cryptoService = CryptoService.shared
    private let keychainService = KeychainService.shared
    
    private let baseURL = "https://us-central1-YOUR-PROJECT-ID.cloudfunctions.net"
    
    private init() {}
    
    func registerDeviceIfNeeded() async throws {
        let installId = keychainService.getOrCreateInstallId()
        
        if UserDefaults.standard.bool(forKey: "deviceRegistered") {
            return
        }
        
        let (_, publicKeyData) = try cryptoService.getOrCreateKeyPair()
        let publicKeyBase64 = publicKeyData.base64EncodedString()
        
        let requestData: [String: Any] = [
            "data": [
                "deviceId": installId,
                "publicKey": publicKeyBase64
            ]
        ]
        
        let url = URL(string: "\(baseURL)/registerDevice")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw FirebaseBackendError.registrationFailed
        }
        
        UserDefaults.standard.set(true, forKey: "deviceRegistered")
        AppLogger.log("Device registered successfully")
    }
    
    func transformText(_ text: String, instruction: String) async throws -> (result: String, quota: QuotaInfo) {
        let installId = keychainService.getOrCreateInstallId()
        
        let signature = try cryptoService.sign(
            deviceId: installId,
            text: text,
            instruction: instruction
        )
        
        let requestData: [String: Any] = [
            "data": [
                "deviceId": installId,
                "text": text,
                "instruction": instruction,
                "signature": signature
            ]
        ]
        
        let url = URL(string: "\(baseURL)/transform")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw FirebaseBackendError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 429 {
                throw FirebaseBackendError.rateLimitExceeded
            } else if httpResponse.statusCode == 401 {
                throw FirebaseBackendError.invalidSignature
            }
            throw FirebaseBackendError.transformFailed
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let resultData = json?["result"] as? [String: Any],
              let transformedText = resultData["result"] as? String,
              let quotaData = resultData["quota"] as? [String: Any],
              let used = quotaData["used"] as? Int,
              let limit = quotaData["limit"] as? Int,
              let resetsAt = quotaData["resetsAt"] as? String else {
            throw FirebaseBackendError.invalidResponse
        }
        
        let quota = QuotaInfo(used: used, limit: limit, resetsAt: resetsAt)
        AppLogger.log("Transform successful. Quota: \(used)/\(limit)")
        
        return (transformedText, quota)
    }
}

struct QuotaInfo {
    let used: Int
    let limit: Int
    let resetsAt: String
}

enum FirebaseBackendError: LocalizedError {
    case registrationFailed
    case transformFailed
    case rateLimitExceeded
    case invalidSignature
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .registrationFailed:
            return Strings.Errors.registrationFailed
        case .transformFailed:
            return Strings.Errors.transformFailed
        case .rateLimitExceeded:
            return Strings.Errors.rateLimitExceeded
        case .invalidSignature:
            return Strings.Errors.invalidSignature
        case .invalidResponse:
            return Strings.Errors.invalidResponse
        }
    }
}
