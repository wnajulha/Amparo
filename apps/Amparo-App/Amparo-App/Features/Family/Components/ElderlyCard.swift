import SwiftUI

struct ElderlyCard: View {
    let elderly: Elderly

    var body: some View {
        HStack(spacing: Spacing.medium) {
            AvatarView(initials: elderly.name.initials, size: 48)

            VStack(alignment: .leading, spacing: 2) {
                Text(elderly.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.textPrimary)
                Text("\(elderly.age) anos · Idoso(a)")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()

            Image(systemName: Icon.back)
                .rotationEffect(.degrees(180))
                .foregroundStyle(Color.textSecondary)
        }
        .padding(Spacing.medium)
        .background(Color(.brandLight))
        .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
    }
}
