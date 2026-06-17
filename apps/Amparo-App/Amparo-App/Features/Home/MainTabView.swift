import SwiftUI

struct MainTabView: View {
    @Environment(AuthSession.self) private var authSession

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Início", systemImage: Icon.home)
            }

            NavigationStack {
                TaskListView()
            }
            .tabItem {
                Label("Agenda", systemImage: Icon.agenda)
            }

            NavigationStack {
                DocumentListView()
            }
            .tabItem {
                Label("Docs", systemImage: Icon.docs)
            }

            NavigationStack {
                FamilyView()
            }
            .tabItem {
                Label("Família", systemImage: Icon.family)
            }

            NavigationStack {
                ElderlyDetailView()
            }
            .tabItem {
                Label("Perfil", systemImage: Icon.profile)
            }
        }
        .tint(Color.brandNavy)
    }
}
