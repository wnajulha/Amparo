import SwiftUI

struct DocumentRow: View {
    let document: Document

    private var iconName: String {
        if document.mimeType.contains("pdf") { return Icon.docs }
        if document.mimeType.contains("image") { return Icon.brain }
        return "doc"
    }

    private var iconColor: Color {
        if document.mimeType.contains("pdf") { return .brandNavy }
        if document.mimeType.contains("image") { return .accentPurple }
        return .brandBlue
    }

    var body: some View {
        HStack(spacing: Spacing.medium) {
            ZStack {
                RoundedRectangle(cornerRadius: Radius.small)
                    .fill(iconColor)
                    .frame(width: 40, height: 40)
                Image(systemName: iconName)
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(document.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.textPrimary)
                Text("\(document.formattedSize) · \(document.uploadedAt.dayMonthYear)")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()

            Image(systemName: Icon.download)
                .foregroundStyle(Color.textSecondary)
        }
        .padding(Spacing.medium)
        .background(Color.brandLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
    }
}
