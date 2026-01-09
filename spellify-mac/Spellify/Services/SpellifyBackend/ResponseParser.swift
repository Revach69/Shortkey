//
//  ResponseParser.swift
//  Spellify
//
//  Parses backend API responses
//

import Foundation

final class ResponseParser {
    
    func parseTransformResponse(_ data: Data) throws -> (result: String, quota: QuotaInfo) {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let resultData = json?["result"] as? [String: Any],
              let transformedText = resultData["result"] as? String,
              let quotaData = resultData["quota"] as? [String: Any],
              let used = quotaData["used"] as? Int,
              let limit = quotaData["limit"] as? Int,
              let resetsAt = quotaData["resetsAt"] as? String else {
            throw BackendError.invalidResponse
        }
        
        let quotaResponse = QuotaInfoResponse(used: used, limit: limit, resetsAt: resetsAt)
        let quota = quotaResponse.toDomain()
        return (transformedText, quota)
    }
    
    func validateResponse(_ httpResponse: HTTPURLResponse) throws {
        guard (200...299).contains(httpResponse.statusCode) else {
            switch httpResponse.statusCode {
            case 429:
                throw BackendError.rateLimitExceeded
            case 401:
                throw BackendError.invalidSignature
            default:
                throw BackendError.transformFailed
            }
        }
    }
}
