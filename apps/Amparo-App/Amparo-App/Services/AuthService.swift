import Foundation

struct AuthService {
    func register(name: String, token: String) async throws -> User {
        struct Body: Encodable { let name: String }
        return try await APIClient.request("/auth/register", method: .post, body: Body(name: name), token: token)
    }

    func me(token: String) async throws -> User {
        return try await APIClient.request("/auth/me", token: token)
    }
}
