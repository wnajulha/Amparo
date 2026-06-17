import SwiftUI

struct AllergyCard: View {
    let allergies: [String]

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.small) {
            Image(systemName: Icon.warning)
                .foregroundStyle(Color.dangerRed)
            Text(allergies.joined(separator: ", "))
                .font(.body)
                .foregroundStyle(Color.dangerRed)
            Spacer()
        }
        .padding(Spacing.medium)
        .background(Color.dangerRed.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
    }
}
