import Foundation

struct TaskType: Codable, Identifiable {
    let id: String
    let name: String
    let baseType: BaseTaskType?
    let isDefault: Bool
}

enum BaseTaskType: String, Codable {
    case medication  = "MEDICATION"
    case medicalAppt = "MEDICAL_APPT"
    case physical    = "PHYSICAL"
    case nutrition   = "NUTRITION"
    case exam        = "EXAM"
    case general     = "GENERAL"
}
