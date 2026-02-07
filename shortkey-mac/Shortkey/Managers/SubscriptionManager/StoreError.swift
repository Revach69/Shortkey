//
//  StoreError.swift
//  Shortkey
//
//  Subscription-related errors
//

import Foundation

enum StoreError: LocalizedError {
    case failedVerification
    case purchaseFailed
    case productNotFound
    case networkError
    case cancelled
    
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return Strings.Errors.failedVerification
        case .purchaseFailed:
            return Strings.Errors.purchaseFailed
        case .productNotFound:
            return Strings.Errors.productNotFound
        case .networkError:
            return Strings.Errors.networkError
        case .cancelled:
            return "Purchase was cancelled"  // User action, not really an error
        }
    }
}
