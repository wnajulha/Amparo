import SwiftUI

struct AllergiesFormSection: View {
    let allergies: [String]
    @Binding var newAllergy: String
    let onAdd: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Alergias")
                .font(.subheadline).fontWeight(.medium)

            if !allergies.isEmpty {
                AllergyCard(allergies: allergies)
            }

            HStack {
                TextField("+ Adicionar alergia", text: $newAllergy)
                    .onSubmit { onAdd() }
                Button("Adicionar") { onAdd() }
                    .font(.subheadline)
                    .foregroundStyle(Color.brandBlue)
            }
        }
    }
}
