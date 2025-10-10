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
            .listRowBackground(Color("NHSRed"))
            .listRowSeparatorTint(Color("NHSGrey1").opacity(0.2))
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
