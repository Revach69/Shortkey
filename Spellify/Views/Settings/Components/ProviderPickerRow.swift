//
//  ProviderPickerRow.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// AI Provider selection picker row
/// Currently shows OpenAI only, prepared for future expansion
struct ProviderPickerRow: View {
    
    @Binding var selectedProvider: String
    
    private let availableProviders = ["OpenAI"]
    
    var body: some View {
        SettingsRow(label: Strings.Settings.provider) {
            Picker("", selection: $selectedProvider) {
                ForEach(availableProviders, id: \.self) { provider in
                    Text(provider).tag(provider)
                }
            }
            .labelsHidden()
            .frame(width: 120)
        }
    }
}

#Preview {
    Form {
        Section("Provider Selection") {
            ProviderPickerRow(selectedProvider: .constant("OpenAI"))
        }
    }
    .formStyle(.grouped)
    .frame(width: 500)
}

