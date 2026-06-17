import SwiftUI

struct TaskFrequencySection: View {
    let frequencies: [Frequency]
    @Binding var selected: Frequency

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Frequência *")
                .font(.subheadline)
                .fontWeight(.medium)
            HStack(spacing: Spacing.small) {
                ForEach(frequencies, id: \.self) { freq in
                    SelectableChipComponent(title: freq.label, isSelected: selected == freq) {
                        selected = freq
                    }
                }
            }
        }
    }
}
