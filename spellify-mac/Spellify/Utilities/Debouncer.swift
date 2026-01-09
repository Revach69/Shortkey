//
//  Debouncer.swift
//  Spellify
//
//  Modern async/await debouncer using Swift Concurrency
//

import Foundation

/// Thread-safe debouncer using Swift's actor model
/// Delays execution until there's a "quiet period" without new calls
actor Debouncer {
    
    private var task: Task<Void, Never>?
    private let duration: Duration
    
    init(duration: Duration) {
        self.duration = duration
    }
    
    /// Debounce an action - only executes after quiet period
    func debounce(action: @escaping @Sendable () async -> Void) {
        // Cancel previous pending task
        task?.cancel()
        
        // Schedule new task
        task = Task {
            // Wait for the delay
            try? await Task.sleep(for: duration)
            
            // If not cancelled, execute the action
            guard !Task.isCancelled else { return }
            await action()
        }
    }
    
    /// Cancel any pending action
    func cancel() {
        task?.cancel()
        task = nil
    }
}
