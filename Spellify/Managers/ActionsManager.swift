//
//  ActionsManager.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation
import Combine

/// Manages CRUD operations for spell actions with UserDefaults persistence
final class ActionsManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var actions: [SpellAction] = []
    
    // MARK: - Private Properties
    
    private let defaults: UserDefaults
    private let storageKey = "spellify.actions"
    private var saveWorkItem: DispatchWorkItem?
    
    // Reusable encoder/decoder for performance
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    // MARK: - Initialization
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        loadActions()
    }
    
    // MARK: - CRUD Operations
    
    /// Adds a new action
    func add(_ action: SpellAction) {
        actions.append(action)
        saveActions()
    }
    
    /// Updates an existing action
    func update(_ action: SpellAction) {
        guard let index = actions.firstIndex(where: { $0.id == action.id }) else { return }
        actions[index] = action
        saveActions()
    }
    
    /// Deletes an action
    func delete(_ action: SpellAction) {
        actions.removeAll { $0.id == action.id }
        saveActions()
    }
    
    /// Deletes action at specific offsets (for SwiftUI lists)
    func delete(at offsets: IndexSet) {
        actions.remove(atOffsets: offsets)
        saveActions()
    }
    
    /// Moves actions (for reordering)
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
            // Corrupted data - reset to defaults
            actions = SpellAction.defaults
            saveActions()
        }
    }
    
    private func saveActions() {
        // Cancel any pending save
        saveWorkItem?.cancel()
        
        // Debounce saves to avoid excessive writes (batch operations within 0.1s)
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            do {
                let data = try Self.encoder.encode(self.actions)
                self.defaults.set(data, forKey: self.storageKey)
            } catch {
                // Failed to save actions
            }
        }
        
        saveWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)
    }
}



