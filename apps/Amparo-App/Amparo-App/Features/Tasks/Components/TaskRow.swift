import SwiftUI

struct TaskRow: View {
    let task: CareTask
    let onComplete: () -> Void

    private var taskIcon: String {
        switch task.taskType.baseType {
        case .medication:  return Icon.medication
        case .medicalAppt: return Icon.stethoscope
        case .physical:    return Icon.heart
        case .nutrition:   return Icon.medication
        case .exam:        return Icon.exam
        default:           return Icon.agenda
        }
    }

    var body: some View {
        HStack(spacing: Spacing.medium) {
            Image(systemName: taskIcon)
                .foregroundStyle(Color.brandBlue)
                .frame(width: Spacing.xMedium, height: Spacing.xMedium)

            VStack(alignment: .leading, spacing: 2) {
                Text(task.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.textPrimary)

                Text("\(task.startDate.formatted(date: .omitted, time: .shortened)) · \(task.frequency.label)")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()

            StatusBadge(status: task.status)
        }
        .padding(Spacing.medium)
        .background(Color.brandLight)
        .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
    }
}
