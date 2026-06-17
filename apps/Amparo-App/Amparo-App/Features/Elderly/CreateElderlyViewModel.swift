import Foundation

@Observable
@MainActor
final class CreateElderlyViewModel {
    var name = ""
    var birthDate = Date()
    var conditions: [String] = []
    var newCondition = ""
    var allergies: [String] = []
    var newAllergy = ""
    var emergencyContactName = ""
    var emergencyContactPhone = ""
    var emergencyContactRelationship = ""
    var isLoading = false
    var error: String?

    private let elderlyService = ElderlyService()

    var isValid: Bool {
        !name.isEmpty && !conditions.isEmpty && !emergencyContactName.isEmpty && !emergencyContactPhone.isEmpty
    }

    func addCondition() {
        let trimmed = newCondition.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        conditions.append(trimmed)
        newCondition = ""
    }

    func addAllergy() {
        let trimmed = newAllergy.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        allergies.append(trimmed)
        newAllergy = ""
    }

    func save(familyId: String, token: String, onSuccess: (Elderly) -> Void) async {
        guard isValid else { error = "Preencha todos os campos obrigatórios."; return }
        isLoading = true
        defer { isLoading = false }
        let iso = ISO8601DateFormatter()
        let body = CreateElderlyBody(
            name: name,
            birthDate: iso.string(from: birthDate),
            conditions: conditions,
            allergies: allergies,
            emergencyContact: EmergencyContactBody(
                name: emergencyContactName,
                phone: emergencyContactPhone,
                relationship: emergencyContactRelationship
            )
        )
        do {
            let elderly = try await elderlyService.create(familyId: familyId, body: body, token: token)
            onSuccess(elderly)
        } catch let appError as AppError {
            error = appError.errorDescription
        } catch {
            self.error = "Não foi possível cadastrar o idoso."
        }
    }
}
