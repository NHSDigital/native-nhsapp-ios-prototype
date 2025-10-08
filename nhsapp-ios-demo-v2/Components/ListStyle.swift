import SwiftUI

struct NHSListDefaults: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.Text)
            .buttonStyle(NHSButtonTextStyle())
            .toggleStyle(NHSToggleStyle())
            .listSectionSpacing(20)
            .scrollContentBackground(.hidden)
            .background(Color.PageBackground)
    }
}

extension View {
    func nhsListStyle() -> some View {
        modifier(NHSListDefaults())
    }
}
