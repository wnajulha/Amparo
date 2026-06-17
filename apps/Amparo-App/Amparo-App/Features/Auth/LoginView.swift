import SwiftUI

struct LoginView: View {
    @State private var viewModel = LoginViewModel()
    @Environment(AuthSession.self) private var authSession

    var body: some View {
        ZStack {
            Color.brandNavy.ignoresSafeArea()

            VStack(spacing: Spacing.xMedium) {
                Spacer()

                LogoSection()

                VStack(spacing: Spacing.small) {
                    FormField(
                        label: "",
                        icon: "envelope",
                        placeholder: "seu@email.com",
                        text: Bindable(viewModel).email
                    )

                    FormField(
                        label: "",
                        icon: "lock",
                        placeholder: "Senha",
                        text: Bindable(viewModel).password,
                        isSecure: true
                    )
                }

                if let error = viewModel.error {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(Color.dangerRed)
                }

                PrimaryButton(title: "Entrar", isLoading: viewModel.isLoading, action: {
                    Task { await viewModel.signIn(session: authSession) }
                }, backgroundColor: .white, textColor: .brandNavy)

                Button("Esqueci minha senha") {}
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.8))

                Button("Entrar como visitante") {
                    authSession.signInAsMock()
                }
                .font(.subheadline)
                .foregroundStyle(Color.white.opacity(0.6))

                Spacer()

                Button {
                    viewModel.showRegister = true
                } label: {
                    Text("Não tem conta? ")
                        .foregroundStyle(Color.white.opacity(0.7))
                    + Text("Cadastrar")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.white)
                }
                .font(.subheadline)
                .padding(.bottom, Spacing.xMedium)
            }
            .padding(.horizontal, Spacing.xMedium)
        }
        .sheet(isPresented: $viewModel.showRegister) {
            RegisterView()
        }
    }
}
