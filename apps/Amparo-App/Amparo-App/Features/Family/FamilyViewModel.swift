import Foundation

@Observable
@MainActor
final class FamilyViewModel {
    var family: Family?
    var isLoading = false
    var error: String?
    var showInvite = false
    var showCreateFamily = false

    private let familyService = FamilyService()

    func load(familyId: String, token: String) async {
        if token == "mock" {
            family = MockDataProvider.mockFamily
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            family = try await familyService.get(familyId: familyId, token: token)
        } catch {
            self.error = "Não foi possível carregar a família."
        }
    }

    func removeMember(memberId: String, token: String) async {
        guard let familyId = family?.id else { return }
        do {
            try await familyService.removeMember(familyId: familyId, memberId: memberId, token: token)
            family?.members.removeAll { $0.id == memberId }
        } catch let appError as AppError {
            error = appError.errorDescription
        } catch {
            self.error = "Não foi possível remover o membro."
        }
    }
}
