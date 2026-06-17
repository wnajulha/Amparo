import Foundation

@Observable
@MainActor
final class TaskDetailViewModel {
    var isLoading = false
    var error: String?
    var showEditTask = false

    private let taskService = TaskService()

    func delete(task: CareTask, token: String, dismiss: () -> Void) async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await taskService.delete(elderlyId: task.elderlyId, taskId: task.id, token: token)
            dismiss()
        } catch let appError as AppError {
            error = appError.errorDescription
        } catch {
            self.error = "Não foi possível excluir a tarefa."
        }
    }

    func complete(task: CareTask, token: String) async -> CareTask? {
        do {
            return try await taskService.complete(elderlyId: task.elderlyId, taskId: task.id, token: token)
        } catch {
            self.error = "Não foi possível concluir a tarefa."
            return nil
        }
    }
}
