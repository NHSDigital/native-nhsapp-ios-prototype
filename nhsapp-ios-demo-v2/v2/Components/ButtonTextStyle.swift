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
            return Color.destructive
        case .cancel:
            return Color.textSecondary
        default:
            return Color.accentColor
        }
    }
}
