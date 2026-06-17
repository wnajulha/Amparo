//
//  HeaderNavigationComponent.swift
//  Amparo-App
//
//  Created by Filipi Romão on 16/06/26.
//

import SwiftUI

struct HeaderNavigationComponent: View {
    let title: String
    var trailingIcon: String? = nil
    var trailingAction: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(Color(.white))
            Spacer()
            if let icon = trailingIcon, let action = trailingAction {
                Button(action: action) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 36, height: 36)

                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.white)
                    }
                }
            }
        }
        .padding(.vertical, Spacing.small)
        .padding(.horizontal, Spacing.xMedium)
        .background(Color.brandNavy)
        .background(ignoresSafeAreaEdges: .top)
    }
}

#Preview {
    VStack(spacing: 0) {
        HeaderNavigationComponent(title: "Início")
        HeaderNavigationComponent(
            title: "Pacientes",
            trailingIcon: "plus",
            trailingAction: {}
        )
        Spacer()
    }
}
