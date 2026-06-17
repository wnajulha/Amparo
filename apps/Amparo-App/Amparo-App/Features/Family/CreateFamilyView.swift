import SwiftUI

struct CreateFamilyView: View {
    @State private var viewModel = CreateFamilyViewModel()
    @Environment(AuthSession.self) private var authSession
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xMedium) {
                    FormField(
                        label: "Nome da família",
                        icon: Icon.family,
                        placeholder: "Ex: Família Oliveira",
                        text: Bindable(viewModel).familyName
                    )

                    if let error = viewModel.error {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(Color.dangerRed)
                    }

                    PrimaryButton(title: "Criar Família", isLoading: viewModel.isLoading) {
                        Task {
                            await viewModel.save(token: authSession.token) { family in
                            authSession.familyId = family.id
                            dismiss()
                        }
                        }
                    }
                }
                .padding(Spacing.xMedium)
            }
            .navigationTitle("Nova Família")
//            .navigationBarSubtitle("Configure o grupo de cuidados")
            .background(Color.brandLight)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
}
