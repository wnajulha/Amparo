import SwiftUI

struct TaskListView: View {
    @State private var viewModel = TaskListViewModel()
    @Environment(AuthSession.self) private var authSession

    private let filters = ["Tudo", "Medicamento", "Consulta", "Atividade"]

    var body: some View {
        VStack(spacing: 0) {
            HeaderNavigationComponent(
                title: "Agenda",
                trailingIcon: "plus",
                trailingAction: { viewModel.showCreateTask = true }
            )
            TaskFilterBar(filters: filters, selectedFilter: Bindable(viewModel).selectedFilter)

            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.filteredTasks.isEmpty {
                EmptyStateView(icon: Icon.agenda, title: "Sem tarefas", subtitle: "Adicione tarefas à agenda")
            } else {
                TaskList(viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .task(id: authSession.elderlyId) {
            guard let elderlyId = authSession.elderlyId else { return }
            await viewModel.load(elderlyId: elderlyId, token: authSession.token)
        }
        .sheet(isPresented: $viewModel.showCreateTask, onDismiss: {
            Task {
                guard let elderlyId = authSession.elderlyId else { return }
                await viewModel.load(elderlyId: elderlyId, token: authSession.token)
            }
        }) {
            CreateTaskView()
        }
    }
}
