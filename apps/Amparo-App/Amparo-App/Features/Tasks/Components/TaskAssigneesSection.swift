import SwiftUI

struct TaskAssigneesSection: View {
    let task: CareTask

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Responsáveis")
                .font(.headline)
                .foregroundStyle(Color(.textPrimary))

            ForEach(task.assignments) { assignment in
                if let member = assignment.member, let user = member.user {
                    HStack(spacing: Spacing.small) {
                        AvatarView(initials: user.name.initials)
                        Text(user.name)
                            .font(.subheadline)
                        Spacer()
                    }
                }
            }
        }
        .padding(Spacing.medium)
        .background(Color(.brandLight))
        .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
    }
}
