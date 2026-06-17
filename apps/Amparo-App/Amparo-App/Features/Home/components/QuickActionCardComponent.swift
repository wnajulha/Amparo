//
//  QuickActionCardComponent.swift
//  Amparo-App
//
//  Created by Filipi Romão on 16/06/26.
//

import SwiftUI

struct QuickActionCardComponent: View {
    let title: String
    let icon: String

    var body: some View {

        VStack(spacing: Spacing.small) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.brandNavy)
            Text(title)
                .font(.subheadline)
                .foregroundStyle(Color.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.medium)
        .background(Color.brandLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.medium))

    }
}

#Preview {
    QuickActionCardComponent(title: "teste", icon: Icon.heart)
}
