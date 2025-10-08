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
                    .foregroundColor(.accentColor)
                    .font(.system(size: 14, weight: .semibold))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
