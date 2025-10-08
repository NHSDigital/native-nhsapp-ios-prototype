import SwiftUI

struct ExternalLinkPresenter: ViewModifier {
    @EnvironmentObject private var externalLinks: ExternalLinkManager

    func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $externalLinks.presentedURL) { identifiable in
                SafariView(url: identifiable.url)
            }
    }
}

extension View {
    func externalLinkPresenter() -> some View {
        modifier(ExternalLinkPresenter())
    }
}
