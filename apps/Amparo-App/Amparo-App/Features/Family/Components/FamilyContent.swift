import SwiftUI

struct FamilyContent: View {
    let family: Family
    let currentUserId: String?
    var onAddElderly: (() -> Void)? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xMedium) {
                HStack {
                    FamilySectionHeader(title: family.elderly?.isEmpty == false ? "IDOSOS (\(family.elderly!.count))" : "IDOSOS")
                    Spacer()
                    if let action = onAddElderly {
                        Button(action: action) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(Color.brandNavy)
                        }
                    }
                }
                .padding(.horizontal, Spacing.medium)

                if let elderly = family.elderly, !elderly.isEmpty {
                    ForEach(elderly) { person in
                        ElderlyCard(elderly: person)
                    }
                } else {
                    Text("Nenhum idoso cadastrado")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, Spacing.medium)
                }

                let admins = family.members.filter { $0.role == .admin }
                let members = family.members.filter { $0.role == .member }

                if !admins.isEmpty {
                    FamilySectionHeader(title: "ADMINISTRADORES")
                    ForEach(admins) { member in
                        MemberRow(member: member, isCurrentUser: member.userId == currentUserId)
                    }
                }

                if !members.isEmpty {
                    FamilySectionHeader(title: "RESPONSÁVEIS (\(members.count))")
                    ForEach(members) { member in
                        MemberRow(member: member, isCurrentUser: member.userId == currentUserId)
                    }
                }
            }
            .padding(Spacing.medium)
        }
    }
}
