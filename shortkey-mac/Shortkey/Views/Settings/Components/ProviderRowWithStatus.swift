//
//  ProviderRowWithStatus.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// AI Provider selection with inline status indicator
/// Shows picker on left, conditionally shows status + refresh on right
struct ProviderRowWithStatus: View {

    @Binding var selectedProviderId: String
    let providers: [AIModelProvider]
    let status: ConnectionStatus
    let hasStoredKey: Bool
    var onTest: (() -> Void)? = nil

    // MARK: - Status Display

    private var shouldShowStatus: Bool {
        hasStoredKey
    }

    private var statusText: String {
        switch status {
        case .connected:
            return Strings.Settings.connected
        case .connecting:
            return Strings.Common.testing
        case .notConfigured:
            return ""
        case .error(let message):
            return message
        }
    }

    private var statusColor: Color {
        switch status {
        case .connected:
            return .green
        case .connecting:
            return .orange
        case .notConfigured:
            return .secondary
        case .error:
            return .red
        }
    }

    // MARK: - Body

    var body: some View {
        SettingsRow(label: Strings.Settings.provider) {
            HStack(spacing: 8) {
                // Provider picker
                Picker("", selection: $selectedProviderId) {
                    ForEach(providers, id: \.id) { provider in
                        Text(provider.displayName).tag(provider.id)
                    }
                }
                .labelsHidden()
                .frame(width: 120)

                // Status indicator (only when key is stored)
                if shouldShowStatus {
                    Spacer(minLength: 8)

                    // Status dot
                    Circle()
                        .fill(statusColor)
                        .frame(width: 6, height: 6)

                    // Status text
                    Text(statusText)
                        .font(.system(size: 13))
                        .foregroundStyle(statusColor)

                    // Refresh button
                    if let onTest = onTest {
                        Button(action: onTest) {
                            if case .connecting = status {
                                ProgressView()
                                    .scaleEffect(0.6)
                                    .frame(width: 16, height: 16)
                            } else {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        .disabled(status == .connecting)
                        .help(Strings.Common.testConnection)
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    Form {
        Section("Empty State") {
            ProviderRowWithStatus(
                selectedProviderId: .constant("openai"),
                providers: [OpenAIProvider(), AnthropicProvider()],
                status: .notConfigured,
                hasStoredKey: false
            )
        }

        Section("Connected State") {
            ProviderRowWithStatus(
                selectedProviderId: .constant("openai"),
                providers: [OpenAIProvider(), AnthropicProvider()],
                status: .connected(model: "gpt-4o"),
                hasStoredKey: true,
                onTest: {}
            )
        }

        Section("Error State") {
            ProviderRowWithStatus(
                selectedProviderId: .constant("anthropic"),
                providers: [OpenAIProvider(), AnthropicProvider()],
                status: .error(message: "Invalid API key"),
                hasStoredKey: true,
                onTest: {}
            )
        }

        Section("Connecting State") {
            ProviderRowWithStatus(
                selectedProviderId: .constant("openai"),
                providers: [OpenAIProvider(), AnthropicProvider()],
                status: .connecting,
                hasStoredKey: true,
                onTest: {}
            )
        }
    }
    .formStyle(.grouped)
    .frame(width: 500)
}
