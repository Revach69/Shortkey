//
//  ActionsManager.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import Foundation
import Combine
import OSLog

/// Manages CRUD operations for spell actions and chains with UserDefaults persistence
@MainActor
final class ActionsManager: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var actions: [SpellAction] = []
    @Published private(set) var chains: [ActionChain] = []

    // MARK: - Private Properties

    private let defaults: UserDefaults
    private let subscriptionManager: SubscriptionManager
    private let storageKey = "shortkey.actions"
    private let chainsKey = "shortkey.chains"
    private let saveDebouncer = Debouncer(duration: .milliseconds(100))
    private let chainSaveDebouncer = Debouncer(duration: .milliseconds(100))

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
        loadChains()
    }

    // MARK: - Pro Features Access

    var canAddAction: Bool {
        subscriptionManager.hasAccess(to: .unlimitedActions) ||
        actions.count < BusinessRulesConstants.freeActionsLimit
    }

    var remainingFreeActions: Int {
        guard !subscriptionManager.hasAccess(to: .unlimitedActions) else {
            return .max
        }
        return max(0, BusinessRulesConstants.freeActionsLimit - actions.count)
    }

    var canAddChain: Bool {
        subscriptionManager.hasAccess(to: .promptChaining) ||
        chains.count < BusinessRulesConstants.freeChainLimit
    }

    // MARK: - Action CRUD Operations

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

    // MARK: - Chain CRUD Operations

    @discardableResult
    func addChain(_ chain: ActionChain) -> Bool {
        guard canAddChain else {
            AppLogger.log("❌ Cannot add chain: Pro required")
            return false
        }

        chains.append(chain)
        saveChains()
        AppLogger.log("✅ Chain added, total: \(chains.count)")
        return true
    }

    func updateChain(_ chain: ActionChain) {
        guard let index = chains.firstIndex(where: { $0.id == chain.id }) else { return }
        chains[index] = chain
        saveChains()
    }

    func deleteChain(id: UUID) {
        chains.removeAll { $0.id == id }
        saveChains()
    }

    func moveChain(from source: IndexSet, to destination: Int) {
        chains.move(fromOffsets: source, toOffset: destination)
        saveChains()
    }

    /// Look up an action by its ID
    func action(for id: UUID) -> SpellAction? {
        actions.first { $0.id == id }
    }

    // MARK: - Actions Persistence

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
                await self.performSaveActions()
            }
        }
    }

    private func performSaveActions() async {
        do {
            let data = try Self.encoder.encode(self.actions)
            self.defaults.set(data, forKey: self.storageKey)
            AppLogger.log("Actions saved (\(self.actions.count) items)")
        } catch {
            AppLogger.error("Failed to encode actions: \(error)")
        }
    }

    // MARK: - Chains Persistence

    private func loadChains() {
        guard let data = defaults.data(forKey: chainsKey) else {
            chains = []
            return
        }

        do {
            chains = try Self.decoder.decode([ActionChain].self, from: data)
        } catch {
            AppLogger.error("Failed to decode chains: \(error)")
            chains = []
        }
    }

    private func saveChains() {
        Task {
            await chainSaveDebouncer.debounce { [weak self] in
                guard let self = self else { return }
                await self.performSaveChains()
            }
        }
    }

    private func performSaveChains() async {
        do {
            let data = try Self.encoder.encode(self.chains)
            self.defaults.set(data, forKey: self.chainsKey)
            AppLogger.log("Chains saved (\(self.chains.count) items)")
        } catch {
            AppLogger.error("Failed to encode chains: \(error)")
        }
    }
}



