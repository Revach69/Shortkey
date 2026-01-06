//
//  PopoverHeaderView.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Header view showing app name and keyboard shortcut
struct PopoverHeaderView: View {
    
    @AppStorage("shortcutDisplay") private var shortcutDisplay = "⌘⇧S"
    
    var body: some View {
        HStack {
            Text(Strings.Popover.title)
                .font(.headline)
            
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
        .frame(width: 300)
}


