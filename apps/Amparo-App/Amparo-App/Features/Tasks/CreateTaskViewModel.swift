import Foundation

@Observable
@MainActor
final class CreateTaskViewModel {
    var name = ""
    var selectedTaskTypeId = ""
    var selectedFrequency: Frequency = .daily
    var startDate = Date()
    var endDate = Date().addingTimeInterval(86400 * 30)
    var selectedMemberIds: [String] = []
    var taskTypes: [TaskType] = []
    var isLoading = false
    var error: String?

    private let taskService = TaskService()

    var members: [FamilyMember] = []

    var isValid: Bool {
        !name.isEmpty && !selectedTaskTypeId.isEmpty && !selectedMemberIds.isEmpty
    }

    func load(familyId: String, token: String) async {
        if token == "mock" {
            taskTypes = MockDataProvider.mockTaskTypes
            return
        }
        taskTypes = (try? await APIClient.request("/task-types", token: token)) ?? []
        guard !familyId.isEmpty else {
            self.error = "Configure sua família antes de criar tarefas."
            return
        }
        if let family: Family = try? await FamilyService().get(familyId: familyId, token: token) {
            members = family.members
        } else {
            self.error = "Não foi possível carregar os membros da família."
        }
    }

    func save(elderlyId: String, familyId: String, token: String, dismiss: () -> Void) async {
        guard !elderlyId.isEmpty else { error = "Adicione um idoso à família antes de criar tarefas."; return }
        guard isValid else { error = "Preencha todos os campos obrigatórios."; return }
        isLoading = true
        defer { isLoading = false }
        let iso = ISO8601DateFormatter()
        let body = CreateTaskBody(
            name: name,
            taskTypeId: selectedTaskTypeId,
            frequency: selectedFrequency.rawValue,
            startDate: iso.string(from: startDate),
            endDate: iso.string(from: endDate),
            assigneeIds: selectedMemberIds,
            familyId: familyId
        )
        do {
            _ = try await taskService.create(elderlyId: elderlyId, body: body, token: token)
            dismiss()
        } catch let appError as AppError {
            error = appError.errorDescription
        } catch {
            self.error = "Não foi possível criar a tarefa."
        }
    }
}
