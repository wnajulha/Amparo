import SwiftUI

struct TaskDetailView: View {
    let task: CareTask
    @State private var viewModel = TaskDetailViewModel()
    @Environment(AuthSession.self) private var authSession
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack{
            ScrollView {
                VStack(spacing: Spacing.medium) {
                    TaskInfoSection(task: task)
                    TaskAssigneesSection(task: task)

                    Spacer(minLength: Spacing.xLarge)

                    TaskActionButtons(onEdit: {
                        viewModel.showEditTask = true
                    }, onDelete: {
                        Task { await viewModel.delete(task: task, token: authSession.token) { dismiss() } }
                    })
                }
                .padding(Spacing.medium)
            }
        }
        .navigationTitle(task.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.light, for: .navigationBar)
        .background(Color.white)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Editar") { viewModel.showEditTask = true }
                    Button("Excluir", role: .destructive) {
                        Task { await viewModel.delete(task: task, token: authSession.token) { dismiss() } }
                    }
                } label: {
                    Image(systemName: Icon.more)
                }
            }
        }
    }
}
