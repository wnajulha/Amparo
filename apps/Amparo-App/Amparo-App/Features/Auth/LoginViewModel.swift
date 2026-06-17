import Foundation

@Observable
@MainActor
final class LoginViewModel {
    var email = ""
    var password = ""
    var isLoading = false
    var error: String?
    var showRegister = false

    private let authService = AuthService()

    func signIn(session: AuthSession) async {
        guard !email.isEmpty, !password.isEmpty else {
            error = "Preencha e-mail e senha."
            return
        }
        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            try await session.signIn(email: email, password: password)
            let user = try await authService.me(token: session.token)
            session.currentUser = user
            await session.loadContext(token: session.token)
        } catch let appError as AppError {
            error = appError.errorDescription
        } catch {
            self.error = "Erro ao fazer login. Tente novamente."
        }
    }
}
