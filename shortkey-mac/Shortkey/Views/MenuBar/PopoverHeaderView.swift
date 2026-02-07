//
//  PopoverHeaderView.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// Header view showing app name and keyboard shortcut
struct PopoverHeaderView: View {
    
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @AppStorage("shortcutDisplay") private var shortcutDisplay = "⌘⇧S"
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                Text(Strings.Popover.title)
                    .font(.headline)
                
                if subscriptionManager.isProUser {
                    ProBadge()
                }
            }
            
            Spacer()
            
            ShortcutDisplayView(shortcut: shortcutDisplay)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 6)
    }
}

#Preview {
    PopoverHeaderView()
        .environmentObject(SubscriptionManager.shared)
        .frame(width: 300)
}


