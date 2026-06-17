import SwiftUI

struct CreateElderlyView: View {
    let familyId: String
    @State private var viewModel = CreateElderlyViewModel()
    @Environment(AuthSession.self) private var authSession
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var vm = viewModel
        NavigationStack {
            HeaderNavigationComponent(title: "Dados do idoso")
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xMedium) {
                    FormField(label: "Nome completo *", icon: "person", placeholder: "Maria Aparecida Oliveira", text: $vm.name)

                    VStack(alignment: .leading, spacing: Spacing.small) {
                        Text("Data de nascimento *")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        DatePicker("", selection: $vm.birthDate, displayedComponents: .date)
                            .labelsHidden()
                    }

                    ConditionsFormSection(
                        conditions: vm.conditions,
                        newCondition: $vm.newCondition,
                        onAdd: { viewModel.addCondition() },
                        onRemove: { condition in viewModel.conditions.removeAll { $0 == condition } }
                    )

                    AllergiesFormSection(
                        allergies: vm.allergies,
                        newAllergy: $vm.newAllergy,
                        onAdd: { viewModel.addAllergy() }
                    )

                    EmergencyContactFormSection(
                        name: $vm.emergencyContactName,
                        phone: $vm.emergencyContactPhone,
                        relationship: $vm.emergencyContactRelationship
                    )

                    if let error = viewModel.error {
                        Text(error).font(.caption).foregroundStyle(Color.dangerRed)
                    }

                    PrimaryButton(title: "Salvar e Continuar", isLoading: viewModel.isLoading) {
                        Task {
                            await viewModel.save(familyId: familyId, token: authSession.token) { elderly in
                                authSession.elderlyId = elderly.id
                                dismiss()
                            }
                        }
                    }
                }
                .padding(Spacing.xMedium)
            }
            .background(Color.white)
        }
    }
}
