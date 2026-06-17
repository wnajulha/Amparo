import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: Spacing.medium) {
            ProgressView()
                .tint(Color.brandNavy)
            Text("Carregando...")
                .font(.subheadline)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
