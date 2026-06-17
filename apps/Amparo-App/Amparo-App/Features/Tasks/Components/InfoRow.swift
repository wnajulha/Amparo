import SwiftUI

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: Spacing.medium) {
            Image(systemName: icon)
                .foregroundStyle(Color.textSecondary)
                .frame(width: Spacing.xMedium)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
                Text(value)
                    .font(.body)
                    .foregroundStyle(Color.textPrimary)
            }
            Spacer()
        }
    }
}
