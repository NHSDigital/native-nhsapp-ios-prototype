import SwiftUI

// Identifiable wrapper for URLs
struct WebLink: Identifiable {
    let id = UUID()
    let url: URL
}

struct HomeViewV1: View {
    @State private var selectedLink: WebLink? = nil

    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    NavigationLink("Prescriptions", destination: DetailView(index: 0))
                    NavigationLink("Appointments", destination: DetailView(index: 0))
                    NavigationLink("Test results", destination: DetailView(index: 0))
                    NavigationLink("Vaccinations", destination: DetailView(index: 0))
                    NavigationLink("Health conditions", destination: DetailView(index: 0))
                    NavigationLink("Documents", destination: DetailView(index: 0))
                }
                .rowStyle(.white)

                Section(header: Text("NHS information and support")) {
                    Button("Check your symptoms using 111 online") {
                        selectedLink = WebLink(url: URL(string: "https://111.nhs.uk/")!)
                    }
                    Button("Health A to Z") {
                        selectedLink = WebLink(url: URL(string: "https://www.nhs.uk")!)
                    }
                    Button("Find services near you") {
                        selectedLink = WebLink(url: URL(string: "https://www.nhs.uk")!)
                    }
                }
                .rowStyle(.white)
                
                Section {
                    CampaignCard(
                        imageName: "campaign_img",
                        title: "Organ donors save lives",
                        subtitle: "Take two minutes to confirm your organ donation decision",
                        backgroundColor: Color("NHSAppDarkBlue"),
                        chevronColor: Color("NHSAppPaleBlue")
                    ) {
                        DetailView(index: 0)
                    }
                }
                .campaignCardRowStyle()
                
            }
            .nhsListStyle()
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .appHelpToolbar()
            .background(Color.pageBackground)
            .sheet(item: $selectedLink) { link in
                SafariView(url: link.url)
            }
        }
    }
}

#Preview {
    HomeViewV1()
}
