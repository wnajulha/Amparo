import SwiftUI

struct ElderlyDetailView: View {
    @State private var viewModel = ElderlyDetailViewModel()
    @Environment(AuthSession.self) private var authSession

    var body: some View {
        VStack {
            HeaderNavigationComponent(title: "Perfil")
            Group {
                if viewModel.isLoading {
                    LoadingView()
                } else if let elderly = viewModel.elderly {
                    ScrollView {
                        VStack(spacing: Spacing.medium) {
                            ElderlyHeaderSection(elderly: elderly)
                            ElderlyConditionsSection(elderly: elderly)
                            ElderlyAllergiesSection(allergies: elderly.allergies)
                            ElderlyEmergencySection(elderly: elderly)
                        }
                        .padding(.vertical, Spacing.medium)
                    }
                } else {
                    EmptyStateView(icon: Icon.profile, title: "Sem perfil", subtitle: "Nenhum idoso cadastrado ainda")
                }
            }
        }
        .background(Color.white)
        .task {
            guard let elderlyId = authSession.elderlyId else { return }
            await viewModel.load(elderlyId: elderlyId, token: authSession.token)
        }
    }
}

