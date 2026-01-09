//
//  SubscriptionManager.swift
//  Spellify
//
//  Main coordinator for subscription management
//

import Foundation
import StoreKit
import OSLog

/// Manages subscription status and In-App Purchases
@MainActor
final class SubscriptionManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = SubscriptionManager()
    
    // MARK: - Published Properties
    
    /// ⚠️ PRIVATE! Never access directly!
    /// Use hasAccess(to:) instead
    @Published private(set) var isProUser: Bool = false
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading: Bool = false
    
    // MARK: - Dependencies
    
    private let verification: SubscriptionVerification
    private let productLoader: ProductLoader
    private let purchaseHandler: PurchaseHandler
    private var transactionListener: TransactionListener?
    
    // MARK: - Initialization
    
    private init() {
        self.verification = SubscriptionVerification(productID: AppConstants.proSubscriptionProductID)
        self.productLoader = ProductLoader(productID: AppConstants.proSubscriptionProductID)
        self.purchaseHandler = PurchaseHandler(verification: verification)
        self.transactionListener = nil
        
        self.transactionListener = TransactionListener { [weak self] in
            await self?.refreshSubscriptionStatus()
        }
        
        transactionListener?.start()
        
        Task {
            await refreshSubscriptionStatus()
            await loadProducts()
        }
    }
    
    // MARK: - Public API
    
    /// ✅ USE THIS! Check if user has access to a specific Pro feature
    ///
    /// Example:
    /// ```swift
    /// if subscriptionManager.hasAccess(to: .unlimitedActions) {
    ///     // allow creating action
    /// }
    /// ```
    func hasAccess(to feature: ProFeature) -> Bool {
        guard feature.isImplemented else {
            return false
        }
        
        // All Pro features require subscription
        return isProUser
        
        // Future: can add more complex logic here
        // switch feature {
        // case .unlimitedActions:
        //     return isProUser
        // case .experimentalFeature:
        //     return isProUser && userSettings.betaEnabled
        // }
    }
    
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            products = try await productLoader.loadProducts()
        } catch {
            AppLogger.error("Product loading failed: \(error)")
            products = []
        }
    }
    
    func purchase() async throws -> Bool {
        guard let product = products.first else {
            throw StoreError.productNotFound
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let success = try await purchaseHandler.purchase(product)
        
        if success {
            await refreshSubscriptionStatus()
        }
        
        return success
    }
    
    /// For users who reinstalled or switched devices
    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await purchaseHandler.restore()
            await refreshSubscriptionStatus()
            AppLogger.log("✅ Restore completed, isProUser: \(isProUser)")
        } catch {
            AppLogger.error("Restore failed: \(error)")
        }
    }
    
    // MARK: - Private Methods
    
    private func refreshSubscriptionStatus() async {
        let newStatus = await verification.checkSubscriptionStatus()
        isProUser = newStatus
    }
}
