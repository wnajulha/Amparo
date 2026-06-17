import SwiftUI

struct TaskInfoSection: View {
    let task: CareTask

    var body: some View {
        VStack(spacing: Spacing.small) {
            InfoRow(icon: Icon.agenda, label: "Frequência", value: task.frequency.label)
            InfoRow(icon: "calendar", label: "Início", value: task.startDate.dayMonthYear)
            InfoRow(icon: "calendar.badge.checkmark", label: "Fim", value: task.endDate.dayMonthYear)
            StatusBadge(status: task.status)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, Spacing.small)
        }
        .padding(Spacing.medium)
        .background(Color(.brandLight))
        .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
    }
}
