import SwiftUI

struct ElderlyEmergencySection: View {
    let elderly: Elderly

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Contatos de emergência")
                .font(.headline)
                .padding(.horizontal, Spacing.medium)
                .foregroundStyle(Color.textPrimary)

            HStack(spacing: Spacing.medium) {
                AvatarView(initials: elderly.emergencyContact.name.initials)
                VStack(alignment: .leading, spacing: 2) {
                    Text(elderly.emergencyContact.name)
                        .font(.subheadline).fontWeight(.medium)
                        .foregroundStyle(Color.textPrimary)
                    Text(elderly.emergencyContact.phone)
                        .font(.caption).foregroundStyle(Color.textSecondary)
                }
                Spacer()
                Image(systemName: Icon.phone)
                    .foregroundStyle(Color.brandBlue)
            }
            .padding(Spacing.medium)
            .background(Color(.brandLight))
            .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
            .padding(.horizontal, Spacing.medium)
        }
    }
}
