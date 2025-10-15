import SwiftUI

struct HomeView: View {

    // Use an Identifiable item so the cover only shows when non-nil
    struct LinkItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let url: URL
    }

    @State private var selectedLink: LinkItem? = nil

    // State variables for toggle examples
    @State private var toggleOne = true
    @State private var toggleTwo = false

    var body: some View {
        NavigationStack {
            List {

                // Navigation links
                Section {
                    RowLink(title: "Prescriptions") { }
                    RowLink(title: "Appointments") { }
                    RowLink(title: "Test results") { }
                    RowLink(title: "Vacciantions") { }
                    RowLink(title: "Health conditions") { }
                    RowLink(title: "Documents") { }
                }
                .rowStyle(.white)

                // External link rows (multiple)
                Section {
                    ExternalLinkRow(title: "Check your symptoms using 111 online",
                                    url: URL(string: "https://111.nhs.uk/")!) { url in
                                    selectedLink = LinkItem(title: "Check your symptoms using 111 online", url: url)
                    }
                    ExternalLinkRow(title: "Health A to Z",
                                    url: URL(string: "https://www.nhs.uk")!) { url in
                                    selectedLink = LinkItem(title: "Health A to Z", url: url)
                    }
                    ExternalLinkRow(title: "Find services near you",
                                    url: URL(string: "https://www.nhs.uk")!) { url in
                                    selectedLink = LinkItem(title: "Find services near you", url: url)
                    }
                } header: {
                    Text("NHS information and support")
                }
                .rowStyle(.white)

            }
            // Present only when selectedLink != nil
            .fullScreenCover(item: $selectedLink) { link in
                SafariView(url: link.url)
                    .ignoresSafeArea()
            }
            .navigationTitle("Home")
            .nhsListStyle()
        }
        .background(Color.pageBackground)
    }
}

#Preview {
    HomeView()
}
