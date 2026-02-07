//
//  ActionsListView.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// List of actions and chains with edit/delete capabilities
struct ActionsListView: View {

    @EnvironmentObject var actionsManager: ActionsManager
    @EnvironmentObject var subscriptionManager: SubscriptionManager

    @Binding var actionEditorMode: MenuBarPopoverView.ActionEditorMode?
    @Binding var chainEditorMode: MenuBarPopoverView.ChainEditorMode?

    @State private var showPaywall = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // MARK: - Actions Section
            Text(Strings.Popover.actions)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 8)

            ForEach(actionsManager.actions) { action in
                Button(action: {
                    actionEditorMode = .edit(action)
                }) {
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
                    .padding(.vertical, 6)
                    .contentShape(Rectangle())
                }
                .buttonStyle(HoverButtonStyle())
            }

            Button(action: {
                if actionsManager.canAddAction {
                    actionEditorMode = .add
                } else {
                    showPaywall = true
                }
            }) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundStyle(.secondary)
                    Text(Strings.Popover.addAction)
                        .foregroundStyle(.primary)

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .contentShape(Rectangle())
            }
            .buttonStyle(HoverButtonStyle())
            .padding(.bottom, 4)

            // MARK: - Chains Section
            if !actionsManager.chains.isEmpty || subscriptionManager.hasAccess(to: .promptChaining) {
                Divider()
                    .padding(.vertical, 4)

                Text(Strings.Popover.chains)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)

                ForEach(actionsManager.chains) { chain in
                    Button(action: {
                        chainEditorMode = .edit(chain)
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: chain.icon)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.secondary)
                                .frame(width: 16)

                            VStack(alignment: .leading, spacing: 1) {
                                Text(chain.name)
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)

                                Text("\(chain.steps.count) steps")
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(HoverButtonStyle())
                }

                Button(action: {
                    if actionsManager.canAddChain {
                        chainEditorMode = .add
                    } else {
                        showPaywall = true
                    }
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundStyle(.secondary)
                        Text(Strings.Popover.addChain)
                            .foregroundStyle(.primary)

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .contentShape(Rectangle())
                }
                .buttonStyle(HoverButtonStyle())
                .padding(.bottom, 4)
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallSheet()
                .environmentObject(subscriptionManager)
        }
    }
}

#Preview {
    ActionsListView(
        actionEditorMode: .constant(nil),
        chainEditorMode: .constant(nil)
    )
    .environmentObject(ActionsManager(subscriptionManager: .shared))
    .environmentObject(SubscriptionManager.shared)
    .frame(width: 300)
}


