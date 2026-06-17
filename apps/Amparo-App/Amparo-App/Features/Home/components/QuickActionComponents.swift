//
//  QuickActionComponents.swift
//  Amparo-App
//
//  Created by Filipi Romão on 16/06/26.
//

import SwiftUI

struct QuickActionComponents: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text("Atalhos rápidos")
                .font(.headline)
                .foregroundStyle(Color.textPrimary)
                .padding(.horizontal, Spacing.medium)

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: Spacing.medium
            ) {

                NavigationLink {
                    TaskListView()
                } label: {
                    QuickActionCardComponent(
                        title: "Medicamentos",
                        icon: Icon.medication
                    )
                }

                NavigationLink {
                    TaskListView()
                } label: {
                    QuickActionCardComponent(
                        title: "Consultas",
                        icon: Icon.stethoscope
                    )
                }

                NavigationLink {
                    TaskListView()
                } label: {
                    QuickActionCardComponent(
                        title: "Tarefas",
                        icon: Icon.agenda
                    )
                }

                NavigationLink {
                    DocumentListView()
                } label: {
                    QuickActionCardComponent(
                        title: "Documentos",
                        icon: Icon.docs
                    )
                }
            }
            .padding(.horizontal, Spacing.medium)
        }
    }
}

#Preview {
    QuickActionComponents()
}
