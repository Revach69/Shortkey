//
//  SubscriptionSection.swift
//  Shortkey
//
//  Subscription status and management section
//

import SwiftUI

struct SubscriptionSection: View {
    
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @EnvironmentObject var actionsManager: ActionsManager
    
    @State private var showPaywall = false
    
    var body: some View {
        Section {
            SettingsRow(label: Strings.Settings.Subscription.plan) {
                statusView
            }
            
            actionButtons
            
        } header: {
            Text(Strings.Settings.Subscription.title)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallSheet()
                .environmentObject(subscriptionManager)
        }
    }
    
    // MARK: - Subviews
    
    private var statusView: some View {
        HStack(spacing: 6) {
            if subscriptionManager.isProUser {
                ProBadge()
            } else {
                Text(Strings.Settings.Subscription.freeUser)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private var actionButtons: some View {
        if subscriptionManager.isProUser {
            SettingsRow(label: "") {
                Button(Strings.Settings.Subscription.manageSubscription) {
                    openSubscriptionManagement()
                }
                .buttonStyle(.link)
            }
        } else {
            SettingsRow(label: "") {
                HStack(spacing: 12) {
                    Button(Strings.Settings.Subscription.upgradeToPro) {
                        showPaywall = true
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(Strings.Settings.Subscription.restorePurchases) {
                        restorePurchases()
                    }
                    .buttonStyle(.link)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func openSubscriptionManagement() {
        if let url = URL(string: "macappstore://showSubscriptionsPage") {
            NSWorkspace.shared.open(url)
        }
    }
    
    private func restorePurchases() {
        Task {
            await subscriptionManager.restorePurchases()
        }
    }
}

#Preview {
    Form {
        SubscriptionSection()
    }
    .formStyle(.grouped)
    .frame(width: 500)
    .environmentObject(SubscriptionManager.shared)
    .environmentObject(ActionsManager(subscriptionManager: .shared))
}
