//
//  ProviderPickerRow.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// AI Provider selection picker row
struct ProviderPickerRow: View {

    @Binding var selectedProviderId: String
    let providers: [AIModelProvider]

    var body: some View {
        SettingsRow(label: Strings.Settings.provider) {
            Picker("", selection: $selectedProviderId) {
                ForEach(providers, id: \.id) { provider in
                    Text(provider.displayName).tag(provider.id)
                }
            }
            .labelsHidden()
            .fixedSize()
        }
    }
}

#Preview {
    Form {
        Section("Provider Selection") {
            ProviderPickerRow(
                selectedProviderId: .constant("openai"),
                providers: [OpenAIProvider(), AnthropicProvider()]
            )
        }
    }
    .formStyle(.grouped)
    .frame(width: 500)
}
