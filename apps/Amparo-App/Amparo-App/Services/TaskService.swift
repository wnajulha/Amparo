import Foundation

struct TaskService {
    func list(elderlyId: String, token: String) async throws -> [CareTask] {
        return try await APIClient.request("/elderly/\(elderlyId)/tasks", token: token)
    }

    func get(elderlyId: String, taskId: String, token: String) async throws -> CareTask {
        return try await APIClient.request("/elderly/\(elderlyId)/tasks/\(taskId)", token: token)
    }

    func create(elderlyId: String, body: CreateTaskBody, token: String) async throws -> CareTask {
        return try await APIClient.request("/elderly/\(elderlyId)/tasks", method: .post, body: body, token: token)
    }

    func update(elderlyId: String, taskId: String, body: UpdateTaskBody, token: String) async throws -> CareTask {
        return try await APIClient.request("/elderly/\(elderlyId)/tasks/\(taskId)", method: .patch, body: body, token: token)
    }

    func delete(elderlyId: String, taskId: String, token: String) async throws {
        try await APIClient.requestEmpty("/elderly/\(elderlyId)/tasks/\(taskId)", method: .delete, token: token)
    }

    func complete(elderlyId: String, taskId: String, token: String) async throws -> CareTask {
        return try await APIClient.request("/elderly/\(elderlyId)/tasks/\(taskId)/complete", method: .patch, token: token)
    }

    func addAssignee(taskId: String, memberId: String, token: String) async throws -> TaskAssignment {
        struct Body: Encodable { let memberId: String }
        return try await APIClient.request("/tasks/\(taskId)/assignees", method: .post, body: Body(memberId: memberId), token: token)
    }

    func removeAssignee(taskId: String, memberId: String, token: String) async throws {
        try await APIClient.requestEmpty("/tasks/\(taskId)/assignees/\(memberId)", method: .delete, token: token)
    }
}

struct CreateTaskBody: Encodable {
    let name: String
    let taskTypeId: String
    let frequency: String
    let startDate: String
    let endDate: String
    let assigneeIds: [String]
    let familyId: String
}

struct UpdateTaskBody: Encodable {
    let name: String?
    let taskTypeId: String?
    let frequency: String?
    let startDate: String?
    let endDate: String?
}
