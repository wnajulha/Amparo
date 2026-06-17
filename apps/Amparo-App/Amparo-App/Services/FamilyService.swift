import Foundation

struct FamilyService {
    func create(name: String, token: String) async throws -> Family {
        struct Body: Encodable { let name: String }
        return try await APIClient.request("/families", method: .post, body: Body(name: name), token: token)
    }

    func get(familyId: String, token: String) async throws -> Family {
        return try await APIClient.request("/families/\(familyId)", token: token)
    }

    func addMember(familyId: String, userId: String, token: String) async throws -> FamilyMember {
        struct Body: Encodable { let userId: String }
        return try await APIClient.request("/families/\(familyId)/members", method: .post, body: Body(userId: userId), token: token)
    }

    func updateMemberRole(familyId: String, memberId: String, role: MemberRole, token: String) async throws -> FamilyMember {
        struct Body: Encodable { let role: String }
        return try await APIClient.request("/families/\(familyId)/members/\(memberId)", method: .patch, body: Body(role: role.rawValue), token: token)
    }

    func removeMember(familyId: String, memberId: String, token: String) async throws {
        try await APIClient.requestEmpty("/families/\(familyId)/members/\(memberId)", method: .delete, token: token)
    }

    func listMine(token: String) async throws -> [Family] {
        return try await APIClient.request("/families/mine", token: token)
    }
}
