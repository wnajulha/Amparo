import Foundation

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case patch  = "PATCH"
    case delete = "DELETE"
}

struct APIClient {
    static let baseURL = "http://localhost:3000/api"

    private static let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    static func request<T: Decodable>(
        _ path: String,
        method: HTTPMethod = .get,
        body: (some Encodable)? = Optional<String>.none,
        token: String
    ) async throws -> T {
        guard let url = URL(string: baseURL + path) else {
            throw AppError.network("URL inválida")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(body)
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw AppError.network("Sem conexão com o servidor.")
        }

        guard let http = response as? HTTPURLResponse else {
            throw AppError.network("Resposta inválida do servidor")
        }

        switch http.statusCode {
        case 200...201:
            return try decoder.decode(T.self, from: data)
        case 401:
            throw AppError.unauthorized
        case 404:
            throw AppError.notFound
        default:
            let msg = (try? decoder.decode(APIErrorResponse.self, from: data))?.error ?? "Erro desconhecido"
            throw AppError.serverError(msg)
        }
    }

    static func requestEmpty(
        _ path: String,
        method: HTTPMethod,
        body: (some Encodable)? = Optional<String>.none,
        token: String
    ) async throws {
        guard let url = URL(string: baseURL + path) else {
            throw AppError.network("URL inválida")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(body)
        }

        let (_, response): (Data, URLResponse)
        do {
            (_, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw AppError.network("Sem conexão com o servidor.")
        }

        guard let http = response as? HTTPURLResponse, http.statusCode == 204 else {
            throw AppError.serverError("Operação falhou")
        }
    }
}
