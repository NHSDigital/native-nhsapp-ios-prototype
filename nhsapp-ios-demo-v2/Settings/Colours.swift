import SwiftUI

extension Color {
    static var PageBackground: Color { Color("NHSGrey5") }
    static var Text: Color { Color("NHSBlack") }
    static var TextSecondary: Color { Color("NHSGrey1") }
    static var TextDestructive: Color { Color("NHSRed") }
    static var NHSWhite: Color { Color("NHSWhite") }
}

extension ShapeStyle where Self == Color {
    static var PageBackground: Color { Color.PageBackground }
    static var Text: Color { Color.Text }
    static var TextSecondary: Color { Color.TextSecondary }
    static var TextDestructive: Color { Color.TextDestructive }
}
