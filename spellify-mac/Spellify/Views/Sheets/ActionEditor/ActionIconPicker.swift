//
//  ActionIconPicker.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Icon picker dropdown for action editor
struct ActionIconPicker: View {
    
    @Binding var selectedIcon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(Strings.ActionEditor.icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
            
            Menu {
                ForEach(SFSymbolsConstants.available, id: \.self) { iconName in
                    Button(action: {
                        selectedIcon = iconName
                    }) {
                        HStack {
                            Image(systemName: iconName)
                            if selectedIcon == iconName {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
                
                Divider()
                
                Button(Strings.ActionEditor.browseSymbols) {
                    NSWorkspace.shared.open(NetworkConstants.sfSymbolsURL)
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: selectedIcon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.primary)
                        .frame(width: 20, height: 20)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(6)
            }
            .buttonStyle(.plain)
            .help("Choose Icon")
        }
    }
}

#Preview {
    ActionIconPicker(selectedIcon: .constant("wand.and.stars"))
        .padding()
        .frame(width: 200)
}

