import Foundation

struct CareTask: Codable, Identifiable {
    let id: String
    let name: String
    let frequency: Frequency
    let startDate: Date
    let endDate: Date
    let completedAt: Date?
    let createdAt: Date
    let elderlyId: String
    let taskTypeId: String
    let creatorId: String
    let familyMemberCreatorId: String
    let taskType: TaskType
    let assignments: [TaskAssignment]
    let status: TaskStatus
}

struct TaskAssignment: Codable, Identifiable {
    let id: String
    let assignedAt: Date
    let taskId: String
    let memberId: String
    let userId: String
    let member: FamilyMember?
}

enum TaskStatus: String, Codable {
    case pending    = "PENDING"
    case inProgress = "IN_PROGRESS"
    case overdue    = "OVERDUE"
    case completed  = "COMPLETED"
}

enum Frequency: String, Codable {
    case oneTime = "ONE_TIME"
    case daily   = "DAILY"
    case weekly  = "WEEKLY"
    case monthly = "MONTHLY"

    var label: String {
        switch self {
        case .oneTime: return "Único"
        case .daily:   return "Diário"
        case .weekly:  return "Semanal"
        case .monthly: return "Mensal"
        }
    }
}
