import SwiftUI

struct FormField: View {
    let label: String
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.textPrimary)

            HStack {
                Image(systemName: icon)
                    .foregroundStyle(Color.textSecondary)
                    .frame(width: Spacing.xMedium)

                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding(Spacing.medium)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.medium)
                    .stroke(Color.divider, lineWidth: 1)
            )
        }
    }
}
