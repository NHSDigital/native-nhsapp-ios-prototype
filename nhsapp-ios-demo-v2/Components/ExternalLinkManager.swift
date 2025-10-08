import Foundation
import Combine

final class ExternalLinkManager: ObservableObject {
    @Published var presentedURL: IdentifiableURL?

    func open(_ url: URL) {
        print("🔗 Opening external link:", url.absoluteString)
        presentedURL = IdentifiableURL(url: url)
    }
}

struct IdentifiableURL: Identifiable, Equatable {
    let id = UUID()
    let url: URL
}
