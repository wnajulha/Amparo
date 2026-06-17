import SwiftUI

struct EmergencyContactFormSection: View {
    @Binding var name: String
    @Binding var phone: String
    @Binding var relationship: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Contato de emergência *")
                .font(.subheadline).fontWeight(.medium)

            FormField(label: "Nome", icon: "person", placeholder: "Nome do contato", text: $name)
            FormField(label: "Telefone", icon: Icon.phone, placeholder: "(11) 99999-9999", text: $phone)
            FormField(label: "Relação", icon: "person.2", placeholder: "Ex: Filho, Filha", text: $relationship)
        }
    }
}
