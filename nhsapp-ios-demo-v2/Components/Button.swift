import SwiftUI

struct NHSButton: View {
    enum Style {
        case primary        // filled NHSGreen, white text
        case secondary      // transparent, 2px accent outline, accent text
        case tertiary       // transparent, no outline, accent text
        case warning        // filled NHSRed, white text
        case destructive    // transparent, no outline, NHSRed text
    }

    let title: String
    let style: Style
    let action: () -> Void
    var icon: String? = nil  // Optional SF Symbol name
    var cornerRadius: CGFloat = 20

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .foregroundStyle(foregroundColor)
            .background(background)
            .overlay(borderOverlay)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .contentShape(Rectangle())
    }

    // MARK: - Visuals

    private var foregroundColor: Color {
        switch style {
        case .primary, .warning:
            return Color("NHSWhite")
        case .secondary, .tertiary:
            return .accentColor
        case .destructive:
            return Color("NHSRed")
        }
    }

    @ViewBuilder private var background: some View {
        switch style {
        case .primary:
            Color("NHSGreen")
        case .warning:
            Color("NHSRed")
        default:
            Color.clear
        }
    }

    @ViewBuilder private var borderOverlay: some View {
        switch style {
        case .secondary:
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color.accentColor, lineWidth: 4)
        default:
            EmptyView()
        }
    }
}
