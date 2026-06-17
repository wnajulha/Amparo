import SwiftUI

struct FamilyView: View {
    @State private var viewModel = FamilyViewModel()
    @State private var showCreateElderly = false
    @Environment(AuthSession.self) private var authSession

    var body: some View {
        VStack {
            HeaderNavigationComponent(title: "Família")
            Group {
                if viewModel.isLoading {
                    LoadingView()
                } else if let family = viewModel.family {
                    FamilyContent(
                        family: family,
                        currentUserId: authSession.currentUser?.id,
                        onAddElderly: { showCreateElderly = true }
                    )
                } else {
                    NoFamilyContent {
                        viewModel.showCreateFamily = true
                    }
                }
            }
        }
        .background(Color.white)
        .task(id: authSession.familyId) {
            guard let familyId = authSession.familyId else { return }
            await viewModel.load(familyId: familyId, token: authSession.token)
        }
        .sheet(isPresented: $viewModel.showCreateFamily) {
            CreateFamilyView()
        }
        .sheet(isPresented: $showCreateElderly, onDismiss: {
            Task {
                guard let familyId = authSession.familyId else { return }
                await viewModel.load(familyId: familyId, token: authSession.token)
            }
        }) {
            CreateElderlyView(familyId: authSession.familyId ?? "")
        }
    }
}
