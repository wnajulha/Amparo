import SwiftUI

struct TaskAssigneesFormSection: View {
    let members: [FamilyMember]
    @Binding var selectedMemberIds: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Responsáveis *")
                .font(.headline)

            if members.isEmpty {
                Text("Carregando membros...")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], alignment: .leading) {
                    ForEach(members) { member in
                        if let name = member.user?.name {
                            SelectableChipComponent(
                                title: name,
                                isSelected: selectedMemberIds.contains(member.id),
                                action: { toggle(member.id) }
                            )
                        }
                    }
                }
            }
        }
        .padding(Spacing.medium)
        .background(Color.brandLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
    }

    private func toggle(_ id: String) {
        if selectedMemberIds.contains(id) {
            selectedMemberIds.removeAll { $0 == id }
        } else {
            selectedMemberIds.append(id)
        }
    }
}
