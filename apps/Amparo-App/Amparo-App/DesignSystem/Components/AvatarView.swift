import SwiftUI

struct AvatarView: View {
    let initials: String
    var size: CGFloat = 40

    private var background: Color {
        let colors: [Color] = [.brandBlue, .brandNavy, .accentPurple, .successGreen]
        let index = abs(initials.hashValue) % colors.count
        return colors[index]
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(background.opacity(0.15))
            Text(initials)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(background)
        }
        .frame(width: size, height: size)
    }
}
