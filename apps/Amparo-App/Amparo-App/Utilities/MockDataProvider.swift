import Foundation

enum MockDataProvider {

    static let mockUser = User(
        id: "mock-user-1",
        email: "visitante@amparo.app",
        name: "Visitante",
        createdAt: Date()
    )

    static let mockElderly = Elderly(
        id: "mock-elderly-1",
        name: "José da Silva",
        birthDate: Calendar.current.date(from: DateComponents(year: 1945, month: 3, day: 15))!,
        conditions: ["Hipertensão", "Diabetes Tipo 2", "Artrite"],
        allergies: ["Penicilina", "AAS"],
        emergencyContact: EmergencyContact(
            name: "Ana Silva",
            phone: "(11) 98765-4321",
            relationship: "Filha"
        ),
        createdAt: Date(),
        familyId: "mock-family-1"
    )

    static let mockFamily = Family(
        id: "mock-family-1",
        name: "Família Silva",
        createdAt: Date(),
        members: [
            FamilyMember(
                id: "mock-member-1",
                role: .admin,
                joinedAt: Date(),
                userId: "mock-user-1",
                familyId: "mock-family-1",
                user: mockUser
            ),
            FamilyMember(
                id: "mock-member-2",
                role: .member,
                joinedAt: Date(),
                userId: "mock-user-2",
                familyId: "mock-family-1",
                user: User(id: "mock-user-2", email: "maria@exemplo.com", name: "Maria Silva", createdAt: Date())
            )
        ],
        elderly: [mockElderly]
    )

    static let mockTaskTypes = [
        TaskType(id: "tt-1", name: "Medicamento", baseType: .medication, isDefault: true),
        TaskType(id: "tt-2", name: "Consulta",    baseType: .medicalAppt, isDefault: true),
        TaskType(id: "tt-3", name: "Atividade",   baseType: .physical,    isDefault: true)
    ]

    static let mockTasks: [CareTask] = [
        CareTask(
            id: "task-1",
            name: "Losartana 50mg",
            frequency: .daily,
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 30),
            completedAt: nil,
            createdAt: Date(),
            elderlyId: "mock-elderly-1",
            taskTypeId: "tt-1",
            creatorId: "mock-user-1",
            familyMemberCreatorId: "mock-member-1",
            taskType: TaskType(id: "tt-1", name: "Medicamento", baseType: .medication, isDefault: true),
            assignments: [],
            status: .pending
        ),
        CareTask(
            id: "task-2",
            name: "Consulta Cardiologista",
            frequency: .oneTime,
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400),
            completedAt: nil,
            createdAt: Date(),
            elderlyId: "mock-elderly-1",
            taskTypeId: "tt-2",
            creatorId: "mock-user-1",
            familyMemberCreatorId: "mock-member-1",
            taskType: TaskType(id: "tt-2", name: "Consulta", baseType: .medicalAppt, isDefault: true),
            assignments: [],
            status: .inProgress
        ),
        CareTask(
            id: "task-3",
            name: "Metformina 850mg",
            frequency: .daily,
            startDate: Date().addingTimeInterval(-86400),
            endDate: Date().addingTimeInterval(86400 * 30),
            completedAt: nil,
            createdAt: Date(),
            elderlyId: "mock-elderly-1",
            taskTypeId: "tt-1",
            creatorId: "mock-user-1",
            familyMemberCreatorId: "mock-member-1",
            taskType: TaskType(id: "tt-1", name: "Medicamento", baseType: .medication, isDefault: true),
            assignments: [],
            status: .overdue
        ),
        CareTask(
            id: "task-4",
            name: "Caminhada 30min",
            frequency: .daily,
            startDate: Date().addingTimeInterval(-3600),
            endDate: Date().addingTimeInterval(86400 * 30),
            completedAt: Date().addingTimeInterval(-1800),
            createdAt: Date(),
            elderlyId: "mock-elderly-1",
            taskTypeId: "tt-3",
            creatorId: "mock-user-1",
            familyMemberCreatorId: "mock-member-1",
            taskType: TaskType(id: "tt-3", name: "Atividade", baseType: .physical, isDefault: true),
            assignments: [],
            status: .completed
        )
    ]

    static let mockDocuments: [Document] = [
        Document(
            id: "doc-1",
            name: "Receita Médica - Jan 2025.pdf",
            fileUrl: "https://example.com/doc1.pdf",
            mimeType: "application/pdf",
            sizeBytes: 204800,
            uploadedAt: Date().addingTimeInterval(-86400 * 5),
            elderlyId: "mock-elderly-1"
        ),
        Document(
            id: "doc-2",
            name: "Exame de Sangue - Dez 2024.pdf",
            fileUrl: "https://example.com/doc2.pdf",
            mimeType: "application/pdf",
            sizeBytes: 512000,
            uploadedAt: Date().addingTimeInterval(-86400 * 30),
            elderlyId: "mock-elderly-1"
        )
    ]
}
