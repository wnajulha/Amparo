import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    let action: () -> Void
    var backgroundColor: Color = .primary
    var textColor: Color = .white

    var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
        }
        .background(backgroundColor)
        .foregroundStyle(textColor)
        .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
        .disabled(isLoading)
    }
}
