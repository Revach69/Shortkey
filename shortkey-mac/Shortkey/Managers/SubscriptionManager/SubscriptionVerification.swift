//
//  SubscriptionVerification.swift
//  Shortkey
//
//  Handles subscription verification logic
//

import Foundation
import StoreKit
import OSLog

final class SubscriptionVerification {
    
    private let productID: String
    
    init(productID: String) {
        self.productID = productID
    }
    
    func checkSubscriptionStatus() async -> Bool {
        var foundSubscription = false
        
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                AppLogger.log("⚠️ Unverified transaction")
                continue
            }
            
            if transaction.productID == productID {
                // Check if not revoked (refund, fraud, etc.)
                if transaction.revocationDate == nil {
                    foundSubscription = true
                    AppLogger.log("✅ Found valid subscription")
                    break
                }
            }
        }
        
        AppLogger.log("📊 Subscription status: \(foundSubscription ? "Pro ✨" : "Free")")
        return foundSubscription
    }
    
    /// Cryptographic verification of transaction signature from Apple
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            AppLogger.log("❌ Transaction verification failed")
            throw StoreError.failedVerification
            
        case .verified(let safe):
            AppLogger.log("✅ Transaction verified")
            return safe
        }
    }
}
