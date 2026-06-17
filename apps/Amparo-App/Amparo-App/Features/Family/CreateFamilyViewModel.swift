import Foundation

@Observable
@MainActor
final class CreateFamilyViewModel {
    var familyName = ""
    var isLoading = false
    var error: String?

    private let familyService = FamilyService()

    var isValid: Bool { !familyName.trimmingCharacters(in: .whitespaces).isEmpty }

    func save(token: String, onSuccess: (Family) -> Void) async {
        guard isValid else { error = "Informe o nome da família."; return }
        isLoading = true
        defer { isLoading = false }
        do {
            let family = try await familyService.create(name: familyName, token: token)
            onSuccess(family)
        } catch let appError as AppError {
            error = appError.errorDescription
        } catch {
            self.error = "Não foi possível criar a família."
        }
    }
}
