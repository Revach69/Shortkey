//
//  TransactionListener.swift
//  Spellify
//
//  Monitors transaction updates in real-time
//

import Foundation
import StoreKit
import OSLog

final class TransactionListener {
    
    private var updateTask: Task<Void, Never>?
    private let onTransactionUpdate: () async -> Void
    
    init(onTransactionUpdate: @escaping () async -> Void) {
        self.onTransactionUpdate = onTransactionUpdate
    }
    
    deinit {
        stop()
    }
    
    func start() {
        guard updateTask == nil else { return }
        
        updateTask = Task.detached { [weak self] in
            guard let self = self else { return }
            
            for await result in Transaction.updates {
                guard case .verified(let transaction) = result else {
                    AppLogger.log("⚠️ Unverified transaction update")
                    continue
                }
                
                AppLogger.log("🔄 Transaction updated: \(transaction.productID)")
                await self.onTransactionUpdate()
                await transaction.finish()
            }
        }
        
        AppLogger.log("👂 Transaction listener started")
    }
    
    func stop() {
        updateTask?.cancel()
        updateTask = nil
        AppLogger.log("🛑 Transaction listener stopped")
    }
}
