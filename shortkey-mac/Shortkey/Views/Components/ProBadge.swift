//
//  ProBadge.swift
//  Shortkey
//
//  Pro user badge component
//

import SwiftUI

struct ProBadge: View {
    
    var body: some View {
        Text("PRO")
            .font(.caption2.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(red: 0.85, green: 0.65, blue: 0.13))
            )
    }
}

#Preview {
    VStack(spacing: 20) {
        // In header
        HStack {
            Text("Shortkey")
                .font(.headline)
            ProBadge()
        }
        
        // Dark background test
        HStack {
            Text("Shortkey")
                .font(.headline)
            ProBadge()
        }
        .padding()
        .background(Color.black.opacity(0.1))
    }
    .padding()
}
