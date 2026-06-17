//
//  TodaySection.swift
//  Amparo-App
//
//  Created by Filipi Romão on 16/06/26.
//

import SwiftUI

struct TodaySection: View {
    @State var viewModel: HomeViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            HStack {
                Text("Hoje")
                    .font(.headline)
                    .foregroundStyle(Color.textPrimary)
                Spacer()
                Button("Ver todos") {}
                    .font(.subheadline)
                    .foregroundStyle(Color.brandBlue)
            }
            .padding(.horizontal, Spacing.medium)

            if viewModel.isLoading {
                LoadingView()
                    .frame(height: 120)
            } else if viewModel.todayTasks.isEmpty {
                EmptyStateView(icon: Icon.agenda, title: "Sem tarefas hoje", subtitle: "Todas as tarefas foram concluídas")
                    .frame(height: 120)
            } else {
                ForEach(viewModel.todayTasks) { task in
                    TaskRow(task: task) {}
                        .padding(.horizontal, Spacing.medium)
                }
            }
        }
    }
}


