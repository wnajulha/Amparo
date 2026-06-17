import SwiftUI

struct RootView: View {
    @Environment(AuthSession.self) private var authSession

    var body: some View {
        Group {
            if authSession.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .task {
            await authSession.restoreSession()
        }
    }
}
