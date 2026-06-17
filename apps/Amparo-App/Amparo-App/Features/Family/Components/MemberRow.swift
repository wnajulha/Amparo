import SwiftUI

struct MemberRow: View {
    let member: FamilyMember
    var isCurrentUser: Bool = false
    var onToggleAdmin: ((Bool) -> Void)?

    var body: some View {
        HStack(spacing: Spacing.medium) {
            AvatarView(initials: member.user?.name.initials ?? "?")

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(member.user?.name ?? "Usuário")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.textPrimary)
                    if isCurrentUser {
                        Text("Você")
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                Text(member.role == .admin ? "Administrador" : "Responsável")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()

            if member.role == .admin {
                Text("Admin")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.brandNavy)
                    .padding(.horizontal, Spacing.small)
                    .padding(.vertical, 4)
                    .background(Color.brandLight)
                    .clipShape(Capsule())
            }
        }
        .padding(Spacing.medium)
        .background(Color(.brandLight))
        .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
    }
}
