import SwiftUI

struct UploadZone: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.medium) {
                Image(systemName: Icon.upload)
                    .font(.system(size: 32))
                    .foregroundStyle(Color.brandBlue)

                VStack(spacing: 4) {
                    Text("Enviar documento")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.textPrimary)
                    Text("Toque para selecionar")
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(Spacing.xLarge)
            .background(Color.brandBlue.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: Radius.large))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.large)
                    .strokeBorder(Color.brandBlue.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [6]))
            )
        }
    }
}
