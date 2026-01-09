//
//  Logger.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import OSLog
import os.log

enum AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.spellify.app"
    
    static let general = Logger(subsystem: subsystem, category: "general")
    static let settings = Logger(subsystem: subsystem, category: "settings")
    static let actionPicker = Logger(subsystem: subsystem, category: "actionPicker")
    static let hotkey = Logger(subsystem: subsystem, category: "hotkey")
    static let ai = Logger(subsystem: subsystem, category: "ai")
    static let accessibility = Logger(subsystem: subsystem, category: "accessibility")
    static let subscription = Logger(subsystem: subsystem, category: "subscription")
    
    static func log(_ message: String) {
        general.info("\(message)")
    }
    
    static func error(_ message: String) {
        general.error("\(message)")
    }
}


