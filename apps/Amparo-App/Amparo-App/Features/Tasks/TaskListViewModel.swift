import Foundation

@Observable
@MainActor
final class TaskListViewModel {
    var tasks: [CareTask] = []
    var isLoading = false
    var error: String?
    var selectedFilter: String = "Tudo"
    var showCreateTask = false

    private let taskService = TaskService()

    var filteredTasks: [CareTask] {
        guard selectedFilter != "Tudo" else { return tasks }
        return tasks.filter { task in
            task.taskType.name.localizedCaseInsensitiveContains(selectedFilter)
        }
    }

    var groupedByDate: [(String, [CareTask])] {
        let grouped = Dictionary(grouping: filteredTasks) { task -> String in
            if task.startDate.isToday { return "HOJE" }
            if task.startDate.isTomorrow { return "AMANHÃ" }
            return task.startDate.shortWeekdayDay
        }
        return grouped.sorted { $0.key < $1.key }
    }

    func load(elderlyId: String, token: String) async {
        if token == "mock" {
            tasks = MockDataProvider.mockTasks
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            tasks = try await taskService.list(elderlyId: elderlyId, token: token)
        } catch {
            self.error = "Não foi possível carregar as tarefas."
        }
    }

    func complete(task: CareTask, elderlyId: String, token: String) async {
        do {
            let updated = try await taskService.complete(elderlyId: elderlyId, taskId: task.id, token: token)
            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                tasks[index] = updated
            }
        } catch {
            self.error = "Não foi possível concluir a tarefa."
        }
    }
}
