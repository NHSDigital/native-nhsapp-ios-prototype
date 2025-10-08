import SwiftUI

struct ExternalLinkRow: View {
    let title: String
    let url: URL
    let open: (URL) -> Void   // parent decides how to present

    var body: some View {
        Button {
            open(url)
        } label: {
            HStack {
                Text(title).foregroundColor(.accentColor)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.accentColor)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
