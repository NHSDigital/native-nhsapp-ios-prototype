import SwiftUI

struct NHSListDefaults: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.text)
            .buttonStyle(NHSButtonTextStyle())
            .toggleStyle(NHSToggleStyle())
            .listSectionSpacing(20)
            .scrollContentBackground(.hidden)
            .background(Color.pageBackground)
    }
}

extension View {
    func nhsListStyle() -> some View {
        modifier(NHSListDefaults())
    }
}

#Preview {
    HomeView()
}
