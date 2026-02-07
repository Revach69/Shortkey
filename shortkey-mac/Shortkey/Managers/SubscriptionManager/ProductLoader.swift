//
//  ProductLoader.swift
//  Shortkey
//
//  Handles loading products from App Store
//

import Foundation
import StoreKit
import OSLog

final class ProductLoader {
    
    private let productID: String
    
    init(productID: String) {
        self.productID = productID
    }
    
    func loadProducts() async throws -> [Product] {
        do {
            let products = try await Product.products(for: [productID])
            AppLogger.log("✅ Loaded \(products.count) products")
            return products
        } catch {
            AppLogger.error("Failed to load products: \(error)")
            throw StoreError.networkError
        }
    }
}
