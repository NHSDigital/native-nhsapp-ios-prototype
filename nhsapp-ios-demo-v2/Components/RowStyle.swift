import SwiftUI

struct RowStyle: ViewModifier {
    enum Variant {
        case white
        case grey
        case blue
        case darkBlue
        case paleAquaGreen
        case paleBlue
        case paleGreen
        case paleOrange
        case palePink
        case palePurple
        case paleYellow
    }

    var variant: Variant

    func body(content: Content) -> some View {
        switch variant {
        case .white:
            content
                .listRowBackground(Color("NHSWhite"))
                .listRowSeparatorTint(Color("NHSGrey4"))
            
        case .grey:
            content
                .listRowBackground(Color("NHSGrey5"))
                .listRowSeparatorTint(Color("NHSGrey4"))
            
        case .blue:
            content
                .listRowBackground(Color("NHSBlue"))
                .listRowSeparatorTint(Color("NHSBlue").opacity(0.2))
            
        case .darkBlue:
            content
                .listRowBackground(Color("NHSAppDarkBlue"))
                .listRowSeparatorTint(Color("NHSAppPaleBlue").opacity(0.2))
            
        case .paleAquaGreen:
            content
                .foregroundStyle(Color("NHSAppDarkAquaGreen"))
                .listRowBackground(Color("NHSAppPaleAquaGreen"))
                .listRowSeparatorTint(Color("NHSAppDarkAquaGreen").opacity(0.2))

        case .paleBlue:
            content
                .foregroundStyle(Color("NHSAppDarkBlue"))
                .listRowBackground(Color("NHSAppPaleBlue"))
                .listRowSeparatorTint(Color("NHSAppDarkBlue").opacity(0.2))
            
        case .paleGreen:
            content
                .foregroundStyle(Color("NHSAppDarkGreen"))
                .listRowBackground(Color("NHSAppPaleGreen"))
                .listRowSeparatorTint(Color("NHSAppDarkGreen").opacity(0.2))
            
        case .paleOrange:
            content
                .foregroundStyle(Color("NHSAppDarkOrange"))
                .listRowBackground(Color("NHSAppPaleOrange"))
                .listRowSeparatorTint(Color("NHSAppDarkOrange").opacity(0.2))
            
        case .palePink:
            content
                .foregroundStyle(Color("NHSAppDarkPink"))
                .listRowBackground(Color("NHSAppPalePink"))
                .listRowSeparatorTint(Color("NHSAppDarkPink").opacity(0.2))
            
        case .palePurple:
            content
                .foregroundStyle(Color("NHSAppDarkPurple"))
                .listRowBackground(Color("NHSAppPalePurple"))
                .listRowSeparatorTint(Color("NHSAppDarkPurple").opacity(0.2))
            
        case .paleYellow:
            content
                .foregroundStyle(Color("NHSAppDarkYellow"))
                .listRowBackground(Color("NHSAppPaleYellow"))
                .listRowSeparatorTint(Color("NHSAppDarkYellow").opacity(0.2))
            
        }
    }
}

extension View {
    func rowStyle(_ variant: RowStyle.Variant = .white) -> some View {
        modifier(RowStyle(variant: variant))
    }
}
