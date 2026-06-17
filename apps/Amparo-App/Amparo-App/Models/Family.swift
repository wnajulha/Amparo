import Foundation

struct Family: Codable, Identifiable {
    let id: String
    let name: String
    let createdAt: Date
    var members: [FamilyMember]
    var elderly: [Elderly]?
}

struct FamilyMember: Codable, Identifiable {
    let id: String
    let role: MemberRole
    let joinedAt: Date
    let userId: String
    let familyId: String
    let user: User?
}

enum MemberRole: String, Codable {
    case admin  = "ADMIN"
    case member = "MEMBER"
}
