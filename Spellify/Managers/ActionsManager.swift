//
//  ActionsManager.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation
import Combine
import OSLog

/// Manages CRUD operations for spell actions with UserDefaults persistence
@MainActor
final class ActionsManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var actions: [SpellAction] = []
    
    // MARK: - Private Properties
    
    private let defaults: UserDefaults
    private let subscriptionManager: SubscriptionManager
    private let storageKey = "spellify.actions"
    private let saveDebouncer = Debouncer(duration: .milliseconds(100))
    
    // Reusable encoder/decoder for performance
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    // MARK: - Initialization
    
    init(
        defaults: UserDefaults = .standard,
        subscriptionManager: SubscriptionManager
    ) {
        self.defaults = defaults
        self.subscriptionManager = subscriptionManager
        loadActions()
    }
    
    // MARK: - Pro Features Access
    
    var canAddAction: Bool {
        subscriptionManager.hasAccess(to: .unlimitedActions) ||
        actions.count < BusinessRules.freeActionsLimit
    }
    
    var remainingFreeActions: Int {
        guard !subscriptionManager.hasAccess(to: .unlimitedActions) else {
            return .max
        }
        return max(0, BusinessRules.freeActionsLimit - actions.count)
    }
    
    // MARK: - CRUD Operations
    
    @discardableResult
    func add(_ action: SpellAction) -> Bool {
        guard canAddAction else {
            AppLogger.log("❌ Cannot add action: limit reached")
            return false
        }
        
        actions.append(action)
        saveActions()
        AppLogger.log("✅ Action added, total: \(actions.count)")
        return true
    }
    
    func update(_ action: SpellAction) {
        guard let index = actions.firstIndex(where: { $0.id == action.id }) else { return }
        actions[index] = action
        saveActions()
    }
    
    func delete(_ action: SpellAction) {
        actions.removeAll { $0.id == action.id }
        saveActions()
    }
    
    func delete(at offsets: IndexSet) {
        actions.remove(atOffsets: offsets)
        saveActions()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        actions.move(fromOffsets: source, toOffset: destination)
        saveActions()
    }
    
    // MARK: - Persistence
    
    private func loadActions() {
        guard let data = defaults.data(forKey: storageKey) else {
            // First launch - create default actions
            actions = SpellAction.defaults
            saveActions()
            return
        }
        
        do {
            actions = try Self.decoder.decode([SpellAction].self, from: data)
        } catch {
            AppLogger.error("Failed to decode actions: \(error)")
            // Corrupted data - reset to defaults
            actions = SpellAction.defaults
            saveActions()
        }
    }
    
    private func saveActions() {
        // Debounce saves to avoid excessive writes (batch operations within 100ms)
        Task {
            await saveDebouncer.debounce { [weak self] in
                guard let self = self else { return }
                await self.performSave()
            }
        }
    }
    
    private func performSave() async {
        do {
            let data = try Self.encoder.encode(self.actions)
            self.defaults.set(data, forKey: self.storageKey)
            AppLogger.log("Actions saved (\(self.actions.count) items)")
        } catch {
            AppLogger.error("Failed to encode actions: \(error)")
        }
    }
}



