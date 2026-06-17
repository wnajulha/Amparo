import SwiftUI

struct HomeView: View {
    @State var viewModel = HomeViewModel()
    @Environment(AuthSession.self) private var authSession

    var body: some View {
        VStack{
            HeaderNavigationComponent(title: "Amparo")
            ScrollView{
                VStack(spacing: Spacing.medium) {
                    if let alert = viewModel.pendingAlert {
                        AlertCard(message: "Medicamento pendente: \(alert.name)")
                            .padding(.horizontal, Spacing.medium)
                    }

                    QuickActionComponents()
                    TodaySection(viewModel: viewModel)
                }
                .padding(.vertical, Spacing.medium)
            }
        }
        .background(Color.white)
        .task {
            guard let elderlyId = authSession.elderlyId else { return }
            await viewModel.load(elderlyId: elderlyId, token: authSession.token)
        }
    }

}
