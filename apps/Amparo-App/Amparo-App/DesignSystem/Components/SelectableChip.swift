import SwiftUI

struct f: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, Spacing.medium)
                .padding(.vertical, Spacing.small)
                .background(isSelected ? Color.brandNavy : Color.clear)
                .foregroundStyle(isSelected ? Color.white : Color.brandBlue)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color.brandBlue.opacity(0.4), lineWidth: 1)
                )
        }
    }
}
