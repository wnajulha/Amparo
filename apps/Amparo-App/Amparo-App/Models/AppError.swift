import Foundation

enum AppError: LocalizedError {
    case network(String)
    case unauthorized
    case notFound
    case serverError(String)
    case decoding

    var errorDescription: String? {
        switch self {
        case .network(let msg):    return msg
        case .unauthorized:        return "Sessão expirada. Faça login novamente."
        case .notFound:            return "Recurso não encontrado."
        case .serverError(let msg): return msg
        case .decoding:            return "Erro ao processar os dados."
        }
    }
}

struct APIErrorResponse: Decodable {
    let error: String
}
