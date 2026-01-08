//
//  Network.swift
//  Spellify
//
//  Network and API constants
//

import Foundation

enum Network {
    
    // MARK: - Timeouts
    
    /// API request timeout in seconds
    static let requestTimeout: TimeInterval = 10.0
    
    // MARK: - URLs
    
    /// OpenAI API key page
    static let openAIKeyURL = URL(string: "https://platform.openai.com/api-keys")!
}
