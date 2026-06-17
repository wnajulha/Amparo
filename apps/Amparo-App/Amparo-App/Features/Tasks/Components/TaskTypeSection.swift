import SwiftUI

struct TaskTypeSection: View {
    let taskTypes: [TaskType]
    @Binding var selectedId: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Tipo *")
                .font(.subheadline)
                .fontWeight(.medium)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.small) {
                    ForEach(taskTypes) { type in
                        SelectableChipComponent(title: type.name, isSelected: selectedId == type.id) {
                            selectedId = type.id
                        }
                    }
                }
            }
        }
    }
}
