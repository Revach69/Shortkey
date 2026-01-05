//
//  NotificationManager.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation
import UserNotifications

/// Manages system notifications for Spellify
final class NotificationManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = NotificationManager()
    
    // MARK: - Initialization
    
    init() {
        requestAuthorization()
    }
    
    // MARK: - Public Methods
    
    /// Shows a notification that processing has started
    func showProcessing(actionName: String) {
        showNotification(
            title: "Spellify",
            body: "\(actionName)..."
        )
    }
    
    /// Shows a success notification
    func showSuccess() {
        showNotification(
            title: "Spellify",
            body: Strings.Notifications.success
        )
    }
    
    /// Shows an error notification
    func showError(_ message: String? = nil) {
        showNotification(
            title: "Spellify",
            body: message ?? Strings.Notifications.error
        )
    }
    
    /// Shows a notification when no text is selected
    func showNoSelection() {
        showNotification(
            title: "Spellify",
            body: Strings.Notifications.noSelection
        )
    }
    
    /// Shows a notification when text is too long
    func showTextTooLong() {
        showNotification(
            title: "Spellify",
            body: Strings.Notifications.textTooLong
        )
    }
    
    /// Shows a notification when API key is not configured
    func showAPIKeyNotConfigured() {
        showNotification(
            title: "Spellify",
            body: "Please configure your API key in Settings"
        )
    }
    
    // MARK: - Private Methods
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            // Authorization completed
        }
    }
    
    private func showNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // Deliver immediately
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            // Notification added
        }
    }
}


