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
                
                // Custom row with title, subtitle and a navigation link
                Section {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Image("nhs_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 28)
                                .accessibilityLabel("NHS")
                                .padding(.bottom, 16)
                            Text("David Hunter")
                                .font(.title)
                                .bold()
                                .foregroundColor(.textInverseOnly)
                            Text("\(Text("NHS number: ").bold())123 456 789")
                                .font(.subheadline)
                                .foregroundColor(.textInverseOnly)
                        }
                    }
                    .padding(.top, 8)
                    
                    HStack(spacing: 12) {
                            Button(action: {
                                // Action for changing user
                                print("Change user tapped")
                            }) {
                                Text("Change profile")
                                    .font(.subheadline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 6)
                                    .background(Color("NHSAppDarkBlue").opacity(0.6))
                                    .foregroundColor(.textInverse)
                                    .clipShape(Capsule())
                            }
                            
                            Button(action: {
                                // Action for adding user
                                print("Add user tapped")
                            }) {
                                Text("Add someone")
                                    .font(.subheadline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 6)
                                    .background(Color("NHSAppDarkBlue").opacity(0.6))
                                    .foregroundColor(.textInverse)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.bottom, 4)
    
                }
                .rowStyle(.blue)

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
            .nhsListStyle()
        }
        .background(Color.pageBackground)
    }
}

#Preview {
    HomeView()
}
