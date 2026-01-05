//
//  ModelPickerRow.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Model selection picker row
struct ModelPickerRow: View {
    
    @Binding var selectedModel: AIModel
    let availableModels: [AIModel]
    let onModelSelected: (AIModel) -> Void
    
    var body: some View {
        HStack {
            Text(Strings.Settings.model)
                .frame(width: 80, alignment: .trailing)
            
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
            .frame(maxWidth: 200)
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

