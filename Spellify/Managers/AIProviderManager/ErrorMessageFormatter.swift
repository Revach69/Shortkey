//
//  ErrorMessageFormatter.swift
//  Spellify
//
//  Formats technical errors into user-friendly messages
//

import Foundation

struct ErrorMessageFormatter {
    static func friendlyMessage(from error: Error) -> String {
        let errorDescription = error.localizedDescription.lowercased()
        
        if errorDescription.contains("internet") || errorDescription.contains("offline") {
            return Strings.Common.noInternet
        } else if errorDescription.contains("timeout") || errorDescription.contains("timed out") {
            return Strings.Common.connectionTimeout
        } else if errorDescription.contains("could not connect") || errorDescription.contains("unreachable") {
            return Strings.Common.cannotReachServer
        } else if errorDescription.contains("unauthorized") || errorDescription.contains("401") {
            return Strings.Common.invalidAPIKey
        } else {
            return Strings.Common.connectionFailed
        }
    }
}
