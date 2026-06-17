import SwiftUI

struct CreateTaskView: View {
    @State private var viewModel = CreateTaskViewModel()
    @Environment(AuthSession.self) private var authSession
    @Environment(\.dismiss) private var dismiss

    private let frequencies: [Frequency] = [.daily, .weekly, .monthly, .oneTime]

    var body: some View {
        @Bindable var vm = viewModel
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xMedium) {
                    FormField(label: "Nome da tarefa *", icon: Icon.edit, placeholder: "Ex: Losartana 50mg", text: $vm.name)

                    TaskTypeSection(taskTypes: vm.taskTypes, selectedId: $vm.selectedTaskTypeId)
                    TaskFrequencySection(frequencies: frequencies, selected: $vm.selectedFrequency)
                    TaskDateSection(startDate: $vm.startDate, endDate: $vm.endDate)

                    TaskAssigneesFormSection(
                        members: viewModel.members,
                        selectedMemberIds: $vm.selectedMemberIds
                    )

                    if let error = viewModel.error {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(Color.dangerRed)
                    }

                    PrimaryButton(
                        title: "Criar atividade",
                        isLoading: viewModel.isLoading,
                        action: {
                            Task {
                                await viewModel.save(
                                    elderlyId: authSession.elderlyId ?? "",
                                    familyId: authSession.familyId ?? "",
                                    token: authSession.token
                                ) { dismiss() }
                            }
                        },
                        backgroundColor: Color.brandNavy,
                        textColor: .white
                    )
                    .disabled(!viewModel.isValid)
                }
                .padding(Spacing.xMedium)
            }
            .navigationTitle("Nova Tarefa")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.brandLight)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .task {
                await viewModel.load(familyId: authSession.familyId ?? "", token: authSession.token)
            }
        }
    }
}
