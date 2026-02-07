//
//  PaywallSheet.swift
//  Shortkey
//
//  Paywall for Pro features
//

import SwiftUI
import StoreKit

struct PaywallSheet: View {
    
    // MARK: - Environment
    
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 24) {
            headerView
            featuresView
            subscribeButton
            restoreButton
            termsView
        }
        .padding(24)
        .frame(width: 480, height: 580)
        .alert(Strings.Errors.errorTitle, isPresented: $showError) {
            Button(Strings.Errors.ok, role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            // Already Pro - shouldn't show paywall
            if subscriptionManager.hasAccess(to: .unlimitedActions) {
                dismiss()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Image(systemName: "wand.and.stars")
                .font(.system(size: 56))
                .foregroundStyle(.blue.gradient)
            
            Text(Strings.Subscription.unlockPro)
                .font(.title.bold())
            
            Text(Strings.Subscription.unlockProDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 360)
        }
    }
    
    private var featuresView: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(ProFeature.allCases.filter(\.isImplemented), id: \.self) { feature in
                HStack(spacing: 12) {
                    Image(systemName: feature.icon)
                        .font(.title3)
                        .foregroundStyle(.blue)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(feature.displayName)
                            .font(.subheadline.weight(.semibold))
                        
                        Text(feature.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private var subscribeButton: some View {
        if let product = subscriptionManager.products.first {
            Button {
                purchase(product)
            } label: {
                HStack(spacing: 8) {
                    if isPurchasing {
                        ProgressView()
                            .controlSize(.small)
                    }
                    Text(isPurchasing ?
                         Strings.Subscription.processing :
                         String(format: Strings.Subscription.subscribeButton, product.displayPrice))
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(isPurchasing)
        } else {
            ProgressView(Strings.Subscription.loading)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
        }
    }
    
    private var restoreButton: some View {
        Button {
            restore()
        } label: {
            Text(Strings.Subscription.restorePurchases)
                .font(.subheadline)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.secondary)
        .disabled(isPurchasing)
    }
    
    private var termsView: some View {
        Text(Strings.Subscription.terms)
            .font(.caption2)
            .foregroundStyle(.tertiary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 400)
    }
    
    // MARK: - Actions
    
    private func purchase(_ product: Product) {
        isPurchasing = true
        
        Task {
            do {
                let success = try await subscriptionManager.purchase()
                
                if success {
                    dismiss()
                } else {
                    errorMessage = Strings.Errors.purchaseFailed
                    showError = true
                }
            } catch StoreError.cancelled {
                // User cancelled - not an error, just dismiss loading
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            
            isPurchasing = false
        }
    }
    
    private func restore() {
        isPurchasing = true
        
        Task {
            await subscriptionManager.restorePurchases()
            
            if subscriptionManager.hasAccess(to: .unlimitedActions) {
                dismiss()
            } else {
                errorMessage = Strings.Subscription.noPurchasesFound
                showError = true
            }
            
            isPurchasing = false
        }
    }
}

// MARK: - Preview

#Preview {
    PaywallSheet()
        .environmentObject(SubscriptionManager.shared)
}
