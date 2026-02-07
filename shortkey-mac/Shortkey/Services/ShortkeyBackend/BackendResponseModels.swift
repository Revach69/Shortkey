//
//  BackendResponseModels.swift
//  Shortkey
//
//  DTOs (Data Transfer Objects) for backend API responses
//  These are internal implementation details of the ShortkeyBackend service
//

import Foundation

// MARK: - Generic Response Wrapper

struct BackendResponse<T: Decodable>: Decodable {
    let result: T
}

// MARK: - Transform Response

struct TransformResult: Decodable {
    let result: String
    let quota: QuotaInfoResponse
}

struct QuotaInfoResponse: Decodable {
    let used: Int
    let limit: Int
    let resetsAt: String
    
    /// Convert DTO to domain model
    func toDomain() -> QuotaInfo {
        QuotaInfo(used: used, limit: limit, resetsAt: resetsAt)
    }
}
