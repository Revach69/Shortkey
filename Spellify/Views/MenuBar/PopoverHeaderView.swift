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
            
            Text(shortcutDisplay)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    PopoverHeaderView()
        .frame(width: 300)
}


