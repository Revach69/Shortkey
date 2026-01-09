//
//  QuotaInfo.swift
//  Spellify
//
//  Domain model for user's quota information
//

import Foundation

/// Represents the user's current quota usage
struct QuotaInfo {
    let used: Int
    let limit: Int
    let resetsAt: String
    
    /// Number of requests remaining
    var remaining: Int {
        max(0, limit - used)
    }
    
    /// Whether the quota has been exceeded
    var isExceeded: Bool {
        used >= limit
    }
    
    /// Percentage of quota used (0.0 to 1.0)
    var usagePercentage: Double {
        guard limit > 0 else { return 0 }
        return Double(used) / Double(limit)
    }
}
