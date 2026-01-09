//
//  SettingsSectionFooter.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Footer positioned outside and below an inset-grouped section
/// Matches macOS System Settings pattern (e.g., "Add Focus..." button)
struct SettingsSectionFooter<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            Spacer()
            content
        }
        .padding(.top, 8)
        .padding(.trailing, 20)
        .padding(.bottom, 8)
    }
}

#Preview {
    VStack(spacing: 0) {
        Form {
            Section("Example Section") {
                Text("Row 1")
                Text("Row 2")
            }
        }
        .formStyle(.grouped)
        
        SettingsSectionFooter {
            Button("Add Focus...") {}
        }
    }
    .frame(width: 500, height: 300)
}
