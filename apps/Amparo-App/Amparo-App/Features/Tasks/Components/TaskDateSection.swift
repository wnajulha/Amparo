import SwiftUI

struct TaskDateSection: View {
    @Binding var startDate: Date
    @Binding var endDate: Date

    var body: some View {
        HStack(spacing: Spacing.medium) {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text("Data início *")
                    .font(.subheadline)
                    .fontWeight(.medium)
                DatePicker("", selection: $startDate, displayedComponents: .date)
                    .labelsHidden()
            }
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text("Data fim")
                    .font(.subheadline)
                    .fontWeight(.medium)
                DatePicker("", selection: $endDate, displayedComponents: .date)
                    .labelsHidden()
            }
        }
    }
}
