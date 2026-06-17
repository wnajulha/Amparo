import SwiftUI

struct StatusBadge: View {
    let status: TaskStatus

    private var label: String {
        switch status {
        case .pending:    return "Agend."
        case .inProgress: return "Ativo"
        case .overdue:    return "Atrasado"
        case .completed:  return "Feito"
        }
    }

    private var color: Color {
        switch status {
        case .pending:    return .textSecondary
        case .inProgress: return .alertAmber
        case .overdue:    return .dangerRed
        case .completed:  return .successGreen
        }
    }

    var body: some View {
        Text(label)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, Spacing.small)
            .padding(.vertical, 4)
            .background(color.opacity(0.12))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}
