//
//  ModelPickerRow.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// Model selection picker row
struct ModelPickerRow: View {
    
    @Binding var selectedModel: AIModel
    let availableModels: [AIModel]
    let onModelSelected: (AIModel) -> Void
    
    var body: some View {
        SettingsRow(label: Strings.Settings.model) {
            Picker("", selection: Binding(
                get: { selectedModel },
                set: { newModel in
                    selectedModel = newModel
                    onModelSelected(newModel)
                }
            )) {
                ForEach(availableModels) { model in
                    Text(model.name).tag(model)
                }
            }
            .labelsHidden()
            .fixedSize()
        }
    }
}

#Preview {
    ModelPickerRow(
        selectedModel: .constant(AIModel(
            id: "gpt-4o-mini",
            name: "GPT-4o Mini",
            provider: "openai"
        )),
        availableModels: [
            AIModel(id: "gpt-4o-mini", name: "GPT-4o Mini", provider: "openai"),
            AIModel(id: "gpt-4o", name: "GPT-4o", provider: "openai")
        ],
        onModelSelected: { _ in }
    )
    .padding()
}

