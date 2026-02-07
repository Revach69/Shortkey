//
//  AppConstants.swift
//  Shortkey
//
//  App-wide identifiers and service names
//

import Foundation

enum AppConstants {
    
    // MARK: - Bundle Identifiers
    
    /// Main app bundle identifier (matches Xcode project setting)
    static let bundleIdentifier = "com.drorlapidot.shortkey"
    
    // MARK: - Subscription
    
    /// Pro subscription product ID
    static let proSubscriptionProductID = "\(bundleIdentifier).pro.monthly"
    
    // MARK: - Services
    
    /// Keychain service identifier
    static let keychainServiceName = "\(bundleIdentifier).keychain"
    
    /// Crypto private key tag
    static let privateKeyTag = "\(bundleIdentifier).privateKey"
    
    // MARK: - Logging
    
    /// OSLog subsystem (fallback if Bundle.main.bundleIdentifier is nil)
    static let logSubsystem = bundleIdentifier
}
