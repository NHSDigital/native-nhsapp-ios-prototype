import SwiftUI

struct RowStyle: ViewModifier {
    enum Variant {
        case white
        case paleBlue
        case grey
    }

    var variant: Variant

    func body(content: Content) -> some View {
        switch variant {
        case .white:
            content
                .listRowBackground(Color("NHSWhite"))
                .listRowSeparatorTint(Color("NHSGrey4"))

        case .paleBlue:
            content
                .foregroundStyle(Color("NHSAppDarkBlue"))
                .listRowBackground(Color("NHSAppPaleBlue"))
                .listRowSeparatorTint(Color("NHSAppDarkBlue").opacity(0.2))
            
        case .grey:
            content
                .listRowBackground(Color("NHSGrey5"))
                .listRowSeparatorTint(Color("NHSGrey4"))
        }
    }
}

extension View {
    func rowStyle(_ variant: RowStyle.Variant = .white) -> some View {
        modifier(RowStyle(variant: variant))
    }
}
