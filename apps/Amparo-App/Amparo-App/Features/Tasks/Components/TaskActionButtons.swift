import SwiftUI

struct TaskActionButtons: View {
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: Spacing.medium) {
            Button {
                onEdit()
            } label: {
                HStack(spacing: Spacing.small) {
                    Image(systemName: Icon.edit)
                    Text("Editar")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
            }
            .foregroundStyle(Color.brandNavy)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.medium)
                    .stroke(Color.brandNavy, lineWidth: 1.5)
            )

            DestructiveButton(title: "Excluir", icon: Icon.delete) {
                onDelete()
            }
        }
    }
}
