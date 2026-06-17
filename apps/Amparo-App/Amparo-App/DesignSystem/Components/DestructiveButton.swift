import SwiftUI

struct DestructiveButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.small) {
                Image(systemName: icon)
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
        }
        .foregroundStyle(Color.dangerRed)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.medium)
                .stroke(Color.dangerRed, lineWidth: 1.5)
        )
    }
}
