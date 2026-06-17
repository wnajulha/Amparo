import Foundation

struct Elderly: Codable, Identifiable {
    let id: String
    let name: String
    let birthDate: Date
    let conditions: [String]
    let allergies: [String]
    let emergencyContact: EmergencyContact
    let createdAt: Date
    let familyId: String

    var age: Int {
        Calendar.current.dateComponents([.year], from: birthDate, to: .now).year ?? 0
    }
}

struct EmergencyContact: Codable {
    let name: String
    let phone: String
    let relationship: String
}
