//
//  NotificationManager.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation
import UserNotifications

/// Manages system notifications for Spellify
@MainActor
final class NotificationManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = NotificationManager()
    
    // MARK: - Initialization
    
    init() {
        requestAuthorization()
    }
    
    // MARK: - Public Methods
    
    func showProcessing(actionName: String) {
        showNotification(
            title: "Spellify",
            body: "\(actionName)..."
        )
    }
    
    func showSuccess() {
        showNotification(
            title: "Spellify",
            body: Strings.Notifications.success
        )
    }
    
    func showError(_ message: String? = nil) {
        showNotification(
            title: "Spellify",
            body: message ?? Strings.Notifications.error
        )
    }
    
    func showNoSelection() {
        showNotification(
            title: "Spellify",
            body: Strings.Notifications.noSelection
        )
    }
    
    func showTextTooLong() {
        showNotification(
            title: "Spellify",
            body: Strings.Notifications.textTooLong
        )
    }
    
    func showAPIKeyNotConfigured() {
        showNotification(
            title: "Spellify",
            body: "Please configure your API key in Settings"
        )
    }
    
    // MARK: - Private Methods
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
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
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
        }
    }
}


