//
//  ChainEditorSheet.swift
//  Shortkey
//
//  Created by Shortkey Team on 07/02/2026.
//

import SwiftUI

/// Sheet for creating or editing a chain
struct ChainEditorSheet: View {

    // MARK: - Properties

    let chain: ActionChain?
    let availableActions: [SpellAction]
    let onSave: (ActionChain) -> Void
    let onCancel: () -> Void
    let onDelete: (() -> Void)?

    @State private var name: String = ""
    @State private var icon: String = "link"
    @State private var steps: [ChainStep] = []
    @State private var showingActionPicker = false

    // MARK: - Computed Properties

    private var isEditing: Bool {
        chain != nil
    }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && steps.count >= 2
    }

    private var canAddStep: Bool {
        steps.count < BusinessRulesConstants.maxChainSteps
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            headerView

            Divider()

            ScrollView {
                VStack(spacing: 20) {
                    nameAndIconSection
                    stepsSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 20)
            }

            Divider()

            footerView
        }
        .frame(width: 520, height: 500)
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear(perform: loadChainData)
        .sheet(isPresented: $showingActionPicker) {
            actionPickerSheet
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            Text(isEditing ? Strings.ChainEditor.editChain : Strings.ChainEditor.newChain)
                .font(.headline)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    // MARK: - Name & Icon Section

    private var nameAndIconSection: some View {
        HStack(alignment: .top, spacing: 12) {
            ActionIconPicker(selectedIcon: $icon)

            VStack(alignment: .leading, spacing: 6) {
                Text(Strings.ChainEditor.chainName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)

                TextField(Strings.ChainEditor.chainNamePlaceholder, text: $name)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    // MARK: - Steps Section

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Strings.ChainEditor.steps)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)

            if steps.isEmpty {
                Text(Strings.ChainEditor.minimumSteps)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 16)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                        stepRow(step: step, index: index)

                        if index < steps.count - 1 {
                            HStack {
                                Spacer()
                                Image(systemName: "arrow.down")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(.tertiary)
                                Spacer()
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }

            addStepButton
        }
    }

    private func stepRow(step: ChainStep, index: Int) -> some View {
        let action = availableActions.first { $0.id == step.actionId }

        return HStack(spacing: 12) {
            Text("\(index + 1)")
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(width: 20)

            Image(systemName: action?.icon ?? "questionmark.circle")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
                .frame(width: 16)

            Text(action?.name ?? "Unknown Action")
                .font(.system(size: 14))
                .foregroundColor(action != nil ? .primary : .red)
                .lineLimit(1)

            Spacer()

            Button {
                steps.remove(at: index)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(width: 22, height: 22)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(4)
            }
            .buttonStyle(.plain)
            .help(Strings.Common.remove)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(6)
    }

    private var addStepButton: some View {
        Button {
            showingActionPicker = true
        } label: {
            HStack {
                Image(systemName: "plus")
                    .foregroundStyle(.secondary)
                Text(canAddStep ?
                     Strings.ChainEditor.addStep :
                     String(format: Strings.ChainEditor.stepsLimit, BusinessRulesConstants.maxChainSteps))
                    .foregroundStyle(canAddStep ? .primary : .secondary)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!canAddStep)
    }

    // MARK: - Action Picker Sheet

    private var actionPickerSheet: some View {
        VStack(spacing: 0) {
            HStack {
                Text(Strings.ChainEditor.addStep)
                    .font(.headline)
                Spacer()
                Button(Strings.Common.cancel) {
                    showingActionPicker = false
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)

            Divider()

            ScrollView {
                VStack(spacing: 2) {
                    ForEach(availableActions) { action in
                        Button {
                            steps.append(ChainStep(actionId: action.id))
                            showingActionPicker = false
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: action.icon)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.secondary)
                                    .frame(width: 16)

                                Text(action.name)
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)

                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(HoverButtonStyle())
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .frame(width: 360, height: 300)
        .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Footer

    private var footerView: some View {
        HStack {
            if let onDelete = onDelete {
                Button(Strings.Common.delete, role: .destructive) {
                    onDelete()
                }
                .buttonStyle(.plain)
                .foregroundStyle(.red)
            }

            Spacer()

            Button(Strings.Common.cancel) {
                onCancel()
            }
            .keyboardShortcut(.escape, modifiers: [])

            Button(Strings.Common.save) {
                handleSave()
            }
            .keyboardShortcut(.return, modifiers: .command)
            .buttonStyle(.borderedProminent)
            .disabled(!isValid)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    // MARK: - Methods

    private func loadChainData() {
        guard let chain = chain else { return }
        name = chain.name
        icon = chain.icon
        steps = chain.steps
    }

    private func handleSave() {
        let newChain = ActionChain(
            id: chain?.id ?? UUID(),
            name: name.trimmingCharacters(in: .whitespaces),
            icon: icon,
            steps: steps
        )
        onSave(newChain)
    }
}

// MARK: - Previews

#Preview("New Chain") {
    ChainEditorSheet(
        chain: nil,
        availableActions: SpellAction.defaults,
        onSave: { _ in },
        onCancel: {},
        onDelete: nil
    )
}

#Preview("Edit Chain") {
    let actions = SpellAction.defaults
    ChainEditorSheet(
        chain: ActionChain(
            name: "Fix & Translate",
            icon: "link",
            steps: [
                ChainStep(actionId: actions[0].id),
                ChainStep(actionId: actions[1].id)
            ]
        ),
        availableActions: actions,
        onSave: { _ in },
        onCancel: {},
        onDelete: {}
    )
}
