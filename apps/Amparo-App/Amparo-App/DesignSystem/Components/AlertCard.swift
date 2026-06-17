import SwiftUI

struct AlertCard: View {
    let message: String
    var icon: String = "clock.fill"

    var body: some View {
        HStack(spacing: Spacing.small) {
            Image(systemName: icon)
                .foregroundStyle(Color.alertAmber)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(Color.textPrimary)
            Spacer()
        }
        .padding(Spacing.medium)
        .background(Color.alertAmber.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
    }
}
