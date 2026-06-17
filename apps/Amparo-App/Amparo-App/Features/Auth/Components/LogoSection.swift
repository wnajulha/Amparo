import SwiftUI

struct LogoSection: View {
    var body: some View {
        VStack(spacing: Spacing.medium) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 88, height: 88)
                Image(systemName: "hands.and.sparkles.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.white)
            }

            VStack(spacing: Spacing.small) {
                Text("Amparo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)

                Text("Cuidado que conecta famílias")
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.8))
            }
        }
        .padding(.bottom, Spacing.large)
    }
}
