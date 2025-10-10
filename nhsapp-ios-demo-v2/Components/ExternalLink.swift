import SwiftUI

struct ExternalLinkRow: View {
    let title: String
    let url: URL
    let action: (URL) -> Void

    var body: some View {
        Button {
            action(url)
        } label: {
            HStack {
                Text(title).foregroundColor(.accentColor)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.accentColor.opacity(0.7))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
