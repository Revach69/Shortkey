//
//  AIProviderConstants.swift
//  Shortkey
//
//  AI Provider identifiers and configuration
//

import Foundation

enum AIProviderConstants {
    
    // MARK: - OpenAI
    
    enum OpenAI {
        /// Technical ID for keychain, APIs, internal use
        static let id = "openai"

        /// Display name shown to users
        static let displayName = "OpenAI"

        /// Keychain key format (matches KeychainService.saveAPIKey)
        static let keychainKey = "\(id)-api-key"
    }

    // MARK: - Anthropic

    enum Anthropic {
        /// Technical ID for keychain, APIs, internal use
        static let id = "anthropic"

        /// Display name shown to users
        static let displayName = "Anthropic"

        /// Keychain key format (matches KeychainService.saveAPIKey)
        static let keychainKey = "\(id)-api-key"
    }
}
