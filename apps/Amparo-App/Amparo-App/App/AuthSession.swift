import Foundation
import Supabase

@Observable
final class AuthSession {
    var supabaseSession: Session?
    var currentUser: User?

    var isMock = false
    var elderlyId: String?
    var familyId: String?

    var isAuthenticated: Bool {
        isMock || (supabaseSession != nil && currentUser != nil)
    }

    var token: String {
        isMock ? "mock" : (supabaseSession?.accessToken ?? "")
    }

    private let client = SupabaseClient(
        supabaseURL: URL(string: "https://ztesokmmtyvzvvgwpntj.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp0ZXNva21tdHl2enZ2Z3dwbnRqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE3MTEwNTcsImV4cCI6MjA5NzI4NzA1N30.CDfaVStWUl-Kq7V0rTHjh4bqa6VySrAO1cV-wb5xujk"
    )

    func signIn(email: String, password: String) async throws {
        let session = try await client.auth.signIn(email: email, password: password)
        self.supabaseSession = session
    }

    func signUp(email: String, password: String) async throws {
        let response = try await client.auth.signUp(email: email, password: password)
        self.supabaseSession = response.session
    }

    func signOut() async throws {
        try await client.auth.signOut()
        supabaseSession = nil
        currentUser = nil
    }

    func loadContext(token: String) async {
        guard let families = try? await FamilyService().listMine(token: token),
              let first = families.first else { return }
        self.familyId = first.id
        self.elderlyId = first.elderly?.first?.id
    }

    func restoreSession() async {
        guard let session = try? await client.auth.session else { return }
        self.supabaseSession = session
        self.currentUser = try? await AuthService().me(token: session.accessToken)
        await loadContext(token: session.accessToken)
    }

    func signInAsMock() {
        isMock = true
        currentUser = MockDataProvider.mockUser
        elderlyId = MockDataProvider.mockElderly.id
        familyId = MockDataProvider.mockFamily.id
    }
}
