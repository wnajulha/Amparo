import SwiftUI

struct ElderlyHeaderSection: View {
    let elderly: Elderly

    var body: some View {
        VStack(spacing: Spacing.small) {
            AvatarView(initials: elderly.name.initials, size: 72)

            Text(elderly.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)

            Text("\(elderly.age) anos")
                .font(.subheadline)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.xMedium)
        .foregroundStyle(Color.textPrimary)
    }
}
