import SwiftUI

struct NHSButtonTextStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(
                configuration.role == .destructive ? .TextDestructive : (Color("NHSBlue"))
            )
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}
