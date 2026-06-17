import SwiftUI

struct RegisterView: View {
    @State private var viewModel = RegisterViewModel()
    @Environment(AuthSession.self) private var authSession
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xMedium) {
                    VStack(spacing: Spacing.medium) {
                        FormField(label: "Nome completo", icon: "person", placeholder: "Seu nome", text: Bindable(viewModel).name)
                        FormField(label: "E-mail", icon: "envelope", placeholder: "seu@email.com", text: Bindable(viewModel).email)
                        FormField(label: "Senha", icon: "lock", placeholder: "Mínimo 6 caracteres", text: Bindable(viewModel).password, isSecure: true)
                    }

                    if let error = viewModel.error {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(Color.dangerRed)
                    }

                    PrimaryButton(title: "Criar conta", isLoading: viewModel.isLoading, action: {
                        Task {
                            await viewModel.signUp(session: authSession) { dismiss() }
                        }
                    }, backgroundColor: Color.brandNavy, textColor: .white)
                }
                .padding(Spacing.xMedium)
            }
            .navigationTitle("Criar conta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
            }
            .background(Color.brandLight)
        }
    }
}
