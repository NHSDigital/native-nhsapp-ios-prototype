import SwiftUI

struct RowLink<Label: View, Destination: View>: View {
    @ViewBuilder let label: () -> Label
    @ViewBuilder let destination: () -> Destination
    var chevronColor: Color = .accentColor

    @State private var isPresented = false

    // 1) Custom label (VStack, etc.)
    init(
        chevronColor: Color = .accentColor,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder destination: @escaping () -> Destination
    ) {
        self.label = label
        self.destination = destination
        self.chevronColor = chevronColor
    }

    // 2) Simple title (so RowLink(title: "…")
    init(
        title: String,
        chevronColor: Color = .accentColor,
        @ViewBuilder destination: @escaping () -> Destination
    ) where Label == Text {
        self.label = { Text(title) }
        self.destination = destination
        self.chevronColor = chevronColor
    }

    var body: some View {
        HStack {
            label()
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(chevronColor.opacity(0.7))
        }
        .contentShape(Rectangle())
        .onTapGesture { isPresented = true }
        .navigationDestination(isPresented: $isPresented, destination: destination)
        .buttonStyle(.plain)
        .accessibilityAddTraits(.isButton)
    }
}
