import SwiftUI

@main
struct Amparo_AppApp: App {
    @State private var authSession = AuthSession()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(authSession)
        }
    }
}
