//
//  PurchaseHandler.swift
//  Spellify
//
//  Handles purchase and restore operations
//

import Foundation
import StoreKit
import OSLog

final class PurchaseHandler {
    
    private let verification: SubscriptionVerification
    
    init(verification: SubscriptionVerification) {
        self.verification = verification
    }
    
    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verificationResult):
            let transaction = try verification.checkVerified(verificationResult)
            await transaction.finish()
            
            AppLogger.log("✅ Purchase successful!")
            return true
            
        case .userCancelled:
            AppLogger.log("ℹ️ User cancelled purchase")
            throw StoreError.cancelled
            
        case .pending:
            AppLogger.log("⏳ Purchase pending")
            return false
            
        @unknown default:
            AppLogger.log("❓ Unknown purchase result")
            throw StoreError.purchaseFailed
        }
    }
    
    func restore() async throws {
        do {
            try await AppStore.sync()
            AppLogger.log("✅ Restore successful")
        } catch {
            AppLogger.error("Restore failed: \(error)")
            throw StoreError.networkError
        }
    }
}
