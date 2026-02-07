//
//  ActionEditorHeader.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// Header for the action editor sheet
struct ActionEditorHeader: View {
    
    let isEditing: Bool
    
    var body: some View {
        HStack {
            Text(isEditing ? Strings.ActionEditor.editAction : Strings.ActionEditor.newAction)
                .font(.system(size: 16, weight: .semibold))
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
}

#Preview {
    VStack {
        ActionEditorHeader(isEditing: false)
        Divider()
        ActionEditorHeader(isEditing: true)
    }
}

