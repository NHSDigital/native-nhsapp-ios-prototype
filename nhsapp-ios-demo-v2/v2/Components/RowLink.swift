import SwiftUI

struct RowLink<Label: View, Destination: View>: View {
    @ViewBuilder let label: () -> Label
    @ViewBuilder let destination: () -> Destination

    var chevronColor: Color = .accentColor
    var horizontalPadding: CGFloat = 0

    @State private var isPresented = false

    // 1) Custom label
    init(
        chevronColor: Color = .accentColor,
        horizontalPadding: CGFloat = 0,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder destination: @escaping () -> Destination
    ) {
        self.label = label
        self.destination = destination
        self.chevronColor = chevronColor
        self.horizontalPadding = horizontalPadding
    }

    // 2) Title-only init
    init(
        title: String,
        chevronColor: Color = .accentColor,
        horizontalPadding: CGFloat = 0,
        @ViewBuilder destination: @escaping () -> Destination
    ) where Label == Text {
        self.label = { Text(title) }
        self.destination = destination
        self.chevronColor = chevronColor
        self.horizontalPadding = horizontalPadding
    }

    var body: some View {
        HStack {
            label()
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(chevronColor.opacity(0.7))
                .accessibilityHidden(true)
        }
        .padding(.horizontal, horizontalPadding)
        .contentShape(Rectangle())
        .onTapGesture { isPresented = true }
        .navigationDestination(isPresented: $isPresented, destination: destination)
        .buttonStyle(.plain)
        .accessibilityAddTraits(.isButton)
    }
}
