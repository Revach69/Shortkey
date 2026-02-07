//
//  BackendError.swift
//  Shortkey
//
//  Error types for backend operations
//

import Foundation

enum BackendError: LocalizedError {
    case registrationFailed
    case transformFailed
    case rateLimitExceeded
    case invalidSignature
    case invalidResponse
    case networkError(Error)
    
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
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}
