//
//  NetworkConstants.swift
//  Spellify
//
//  Network and API constants
//

import Foundation

enum NetworkConstants {
    
    // MARK: - Timeouts
    
    /// API request timeout in seconds
    static let requestTimeout: TimeInterval = 10.0
    
    // MARK: - Backend URLs
    
    /// Spellify backend base URL
    /// Update this with your Firebase project ID after deployment
    static let backendBaseURL = "https://us-central1-YOUR-PROJECT-ID.cloudfunctions.net"
    
    // MARK: - External URLs
    
    /// OpenAI API key page
    static let openAIKeyURL = URL(string: "https://platform.openai.com/api-keys")!
}
