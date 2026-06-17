import SwiftUI

struct ElderlyAllergiesSection: View {
    let allergies: [String]

    var body: some View {
        if !allergies.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text("Alergias")
                    .font(.headline)
                    .foregroundStyle(Color.dangerRed)
                AllergyCard(allergies: allergies)
            }
            .padding(.horizontal, Spacing.medium)
        }
    }
}
