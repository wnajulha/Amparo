import Foundation

@Observable
@MainActor
final class HomeViewModel {
    var todayTasks: [CareTask] = []
    var pendingAlert: CareTask?
    var isLoading = false
    var error: String?

    private let taskService = TaskService()

    func load(elderlyId: String, token: String) async {
        if token == "mock" {
            todayTasks = MockDataProvider.mockTasks.filter { $0.status == .pending || $0.status == .inProgress }
            pendingAlert = MockDataProvider.mockTasks.first { $0.status == .overdue }
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            let all = try await taskService.list(elderlyId: elderlyId, token: token)
            todayTasks = all.filter {
                Calendar.current.isDateInToday($0.startDate) || $0.status == .inProgress
            }
            pendingAlert = all.first { $0.status == .overdue }
        } catch {
            self.error = "Não foi possível carregar as tarefas."
        }
    }
}
