import SwiftUI

struct NHSButtonTextStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foregroundColor(for: configuration.role))
            .opacity(configuration.isPressed ? 0.6 : 1)
    }

    private func foregroundColor(for role: ButtonRole?) -> Color {
        switch role {
        case .destructive:
            return Color("NHSRed")
        case .cancel:
            return Color("NHSGrey1")
        default:
            return Color("NHSBlue")
        }
    }
}
