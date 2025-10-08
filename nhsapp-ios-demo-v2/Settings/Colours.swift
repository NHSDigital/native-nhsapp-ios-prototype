import SwiftUI

// 1) Semantic color aliases (single allocation, auto-adapts via Asset variants)
extension Color {
    static let pageBackground   = Color("NHSGrey5")
    static let text             = Color("NHSBlack")
    static let textSecondary    = Color("NHSGrey1")
    static let textDestructive  = Color("NHSRed")
}

// 2) Shorthands so you can write `.foregroundStyle(.text)` etc.
extension ShapeStyle where Self == Color {
    static var pageBackground: Color  { .pageBackground }
    static var text: Color            { .text }
    static var textSecondary: Color   { .textSecondary }
    static var textDestructive: Color { .textDestructive }
}
