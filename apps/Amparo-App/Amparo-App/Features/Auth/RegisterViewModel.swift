import Foundation

@Observable
@MainActor
final class RegisterViewModel {
    var name = ""
    var email = ""
    var password = ""
    var isLoading = false
    var error: String?

    private let authService = AuthService()

    func signUp(session: AuthSession, dismiss: () -> Void) async {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            error = "Preencha todos os campos."
            return
        }
        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            try await session.signUp(email: email, password: password)
            let user = try await authService.register(name: name, token: session.token)
            session.currentUser = user
            dismiss()
        } catch let appError as AppError {
            error = appError.errorDescription
        } catch {
            self.error = error.localizedDescription
        }
    }
}
