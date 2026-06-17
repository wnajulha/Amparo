import SwiftUI

struct NoFamilyContent: View {
    let onCreateFamily: () -> Void

    var body: some View {
        VStack(spacing: Spacing.xMedium) {
            EmptyStateView(
                icon: Icon.family,
                title: "Sem família",
                subtitle: "Crie um grupo familiar para começar a gerenciar os cuidados"
            )

            PrimaryButton(title: "Criar família") {
                onCreateFamily()
            }
            .padding(.horizontal, Spacing.xMedium)
        }
    }
}
