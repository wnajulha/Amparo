import Foundation

struct DocumentService {
    func list(elderlyId: String, token: String) async throws -> [Document] {
        return try await APIClient.request("/elderly/\(elderlyId)/documents", token: token)
    }

    func get(elderlyId: String, documentId: String, token: String) async throws -> Document {
        return try await APIClient.request("/elderly/\(elderlyId)/documents/\(documentId)", token: token)
    }

    func upload(elderlyId: String, fileData: Data, fileName: String, mimeType: String, token: String) async throws -> Document {
        guard let url = URL(string: APIClient.baseURL + "/elderly/\(elderlyId)/documents") else {
            throw AppError.network("URL inválida")
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 201 else {
            throw AppError.serverError("Falha ao enviar documento")
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Document.self, from: data)
    }

    func delete(elderlyId: String, documentId: String, token: String) async throws {
        try await APIClient.requestEmpty("/elderly/\(elderlyId)/documents/\(documentId)", method: .delete, token: token)
    }
}
