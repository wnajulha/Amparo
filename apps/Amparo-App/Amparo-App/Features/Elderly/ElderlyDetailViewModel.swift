import Foundation

@Observable
@MainActor
final class ElderlyDetailViewModel {
    var elderly: Elderly?
    var isLoading = false
    var error: String?

    private let elderlyService = ElderlyService()

    func load(elderlyId: String, token: String) async {
        if token == "mock" {
            elderly = MockDataProvider.mockElderly
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            elderly = try await elderlyService.get(elderlyId: elderlyId, token: token)
        } catch {
            self.error = "Não foi possível carregar o perfil."
        }
    }
}
