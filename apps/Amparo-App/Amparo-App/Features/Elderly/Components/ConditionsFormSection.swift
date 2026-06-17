import SwiftUI

struct ConditionsFormSection: View {
    let conditions: [String]
    @Binding var newCondition: String
    let onAdd: () -> Void
    let onRemove: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Condições médicas *")
                .font(.subheadline).fontWeight(.medium)

            FlowLayout(items: conditions) { condition in
                HStack(spacing: 4) {
                    Text(condition).font(.caption)
                    Button { onRemove(condition) } label: {
                        Image(systemName: "xmark").font(.caption2)
                    }
                }
                .padding(.horizontal, Spacing.small)
                .padding(.vertical, 4)
                .background(Color.brandNavy)
                .foregroundStyle(.white)
                .clipShape(Capsule())
            }

            HStack {
                TextField("+ Adicionar condição", text: $newCondition)
                    .onSubmit { onAdd() }
                Button("Adicionar") { onAdd() }
                    .font(.subheadline)
                    .foregroundStyle(Color.brandBlue)
            }
        }
    }
}
