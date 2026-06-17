import Foundation

struct ElderlyService {
    func list(familyId: String, token: String) async throws -> [Elderly] {
        return try await APIClient.request("/families/\(familyId)/elderly", token: token)
    }

    func create(familyId: String, body: CreateElderlyBody, token: String) async throws -> Elderly {
        return try await APIClient.request("/families/\(familyId)/elderly", method: .post, body: body, token: token)
    }

    func get(elderlyId: String, token: String) async throws -> Elderly {
        return try await APIClient.request("/elderly/\(elderlyId)", token: token)
    }
}

struct CreateElderlyBody: Encodable {
    let name: String
    let birthDate: String
    let conditions: [String]
    let allergies: [String]
    let emergencyContact: EmergencyContactBody
}

struct EmergencyContactBody: Encodable {
    let name: String
    let phone: String
    let relationship: String
}
