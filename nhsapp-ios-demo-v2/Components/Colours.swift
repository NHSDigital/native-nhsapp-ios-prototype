import SwiftUI

// Semantic color aliases (single allocation, auto-adapts via Asset variants)
extension Color {
    static let pageBackground   = Color("NHSGrey5")
    static let text             = Color("NHSBlack")
    static let textSecondary    = Color("NHSGrey1")
    static let textTertiary     = Color("NHSGrey3")
    static let destructive      = Color("NHSRed")
    static let warning          = Color("NHSOrange")
    static let primary         = Color("AccentColor")
    static let textLink         = Color("AccentColor")
}

// Shorthands so you can write `.foregroundStyle(.text)` etc.
extension ShapeStyle where Self == Color {
    static var pageBackground: Color  { .pageBackground }
    static var text: Color            { .text }
    static var textSecondary: Color   { .textSecondary }
    static var textTertiary: Color    { .textTertiary }
    static var destructive: Color     { .destructive }
    static var warning: Color         { .warning }
    static var primary: Color         { .primary}
    static var textLink: Color        { .textLink}
}
