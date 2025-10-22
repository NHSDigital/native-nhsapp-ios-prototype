import SwiftUI

struct ExternalLinkRow: View {
    let title: String
    let url: URL
    let action: (URL) -> Void
    var accessibilityHintText: String? = "Opens in Safari."

    private var host: String {
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.host ?? ""
    }

    var body: some View {
        Button {
            action(url)
        } label: {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(title)
                    .foregroundColor(.accentColor)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 8)

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.accentColor.opacity(0.7))
                    .accessibilityHidden(true)
            }
            .contentShape(Rectangle())
            .accessibilityElement(children: .combine)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(.isLink)
        .accessibilityLabel(title)
        // ✅ use conditional modifiers instead of passing nil directly
        .accessibilityValue(host.isEmpty ? "" : host)
        .accessibilityHint(accessibilityHintText ?? "")
    }
}

#Preview("ExternalLinkRow Example") {
    VStack(spacing: 0) {
        ExternalLinkRow(
            title: "Check your symptoms using 111 online",
            url: URL(string: "https://111.nhs.uk")!
        ) { url in
            print("Opening:", url)
        }

        Divider()

        ExternalLinkRow(
            title: "Find services near you",
            url: URL(string: "https://www.nhs.uk")!,
            action: { url in print("Opening:", url) },
            accessibilityHintText: "Opens this NHS page in Safari."
        )
    }
    .padding()
}
