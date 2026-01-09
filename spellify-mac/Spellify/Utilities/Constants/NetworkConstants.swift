//
//  NetworkConstants.swift
//  Spellify
//
//  Network and API constants
//

import Foundation

enum NetworkConstants {
    
    // MARK: - Timeouts
    
    static let requestTimeout: TimeInterval = 10.0
    
    // MARK: - Backend URLs
    
    /// Update with your Firebase project ID after deployment
    static let spellifyApiBaseURL = "https://us-central1-YOUR-PROJECT-ID.cloudfunctions.net"
    
    // MARK: - Backend Endpoints
    
    enum SpellifyApiEndpoint {
        static let registerDevice = "registerDevice"
        static let transform = "transform"
    }
    
    // MARK: - AI Provider URLs
    
    enum OpenAI {
        static let baseURL = "https://api.openai.com/v1"
        static let apiKeyURL = URL(string: "https://platform.openai.com/api-keys")!
    }
    
    // MARK: - Other External URLs
    
    static let sfSymbolsURL = URL(string: "https://developer.apple.com/sf-symbols/")!
}
