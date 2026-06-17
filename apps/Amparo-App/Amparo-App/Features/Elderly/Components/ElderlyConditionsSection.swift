import SwiftUI

struct ElderlyConditionsSection: View {
    let elderly: Elderly

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Condições médicas")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.small) {
                    ForEach(elderly.conditions, id: \.self) { condition in
                        Text(condition)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, Spacing.medium)
                            .padding(.vertical, Spacing.small)
                            .background(Color.brandNavy)
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(.horizontal, Spacing.medium)
    }
}
