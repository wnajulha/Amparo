import SwiftUI

struct TaskList: View {
    let viewModel: TaskListViewModel
    @Environment(AuthSession.self) private var authSession

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.small, pinnedViews: .sectionHeaders) {
                ForEach(viewModel.groupedByDate, id: \.0) { (dateLabel, tasks) in
                    Section {
                        ForEach(tasks) { task in
                            NavigationLink(destination: TaskDetailView(task: task)) {
                                TaskRow(task: task) {
                                    Task {
                                        guard let elderlyId = tasks.first?.elderlyId else { return }
                                        await viewModel.complete(task: task, elderlyId: elderlyId, token: authSession.token)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, Spacing.medium)
                        }
                    } header: {
                        Text(dateLabel)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, Spacing.medium)
                            .padding(.top, Spacing.small)
                    }
                }
            }
            .padding(.vertical, Spacing.small)
        }
    }
}
