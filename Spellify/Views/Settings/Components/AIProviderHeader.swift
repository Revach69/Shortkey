//
//  AIProviderHeader.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Header for AI provider settings section
struct AIProviderHeader: View {
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "brain")
                .font(.title2)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(Strings.Settings.openAITitle)
                    .font(.headline)
                
                HStack(spacing: 4) {
                    Text(Strings.Settings.openAIDescription)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    
                    Link(Strings.Settings.getAPIKey, destination: Constants.openAIKeyURL)
                        .font(.callout)
                }
            }
        }
    }
}

#Preview {
    AIProviderHeader()
        .padding()
}

