import SwiftUI

struct RowStyle: ViewModifier {
    enum Variant {
        case white
        case paleBlue
    }

    var variant: Variant

    func body(content: Content) -> some View {
        switch variant {
        case .white:
            content
                .listRowBackground(Color("NHSWhite"))
                .listRowSeparatorTint(Color("NHSGrey3").opacity(0.4))

        case .paleBlue:
            content
                .foregroundStyle(Color("NHSAppDarkBlue"))
                .listRowBackground(Color("NHSAppPaleBlue"))
                .listRowSeparatorTint(Color("NHSAppDarkBlue").opacity(0.2))
        }
    }
}

extension View {
    func rowStyle(_ variant: RowStyle.Variant = .white) -> some View {
        modifier(RowStyle(variant: variant))
    }
}
