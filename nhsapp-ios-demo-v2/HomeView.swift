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
    
    // Start hidden so we can animate it in after a delay
    @State private var showPrescriptionCard = false
    
    // Persist dismissal across app launches
    @AppStorage("hidePrescriptionCard") private var hidePrescriptionCard = false

    // Prevent re-scheduling the intro animation repeatedly in the same session
    @State private var didScheduleIntro = false

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
                
                // Prescription card (only if not permanently hidden)
                if !hidePrescriptionCard && showPrescriptionCard {
                    Section {
                        ZStack(alignment: .topTrailing) {

                            HStack(alignment: .center) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Ready to collect")
                                        .font(.body)
                                        .bold()
                                    Text("Ramipril 50mg | Order 557579689")
                                }
                                Spacer(minLength: 40)
                            }

                            Button {
                                withAnimation(.easeInOut) {
                                    // Hide now (animates out)...
                                    showPrescriptionCard = false
                                    // ...and remember to never show it again
                                    hidePrescriptionCard = true
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Color("NHSAppDarkPurple"))
                                    .accessibilityLabel("Dismiss prescription card")
                            }
                        }
                        RowLink(title: "View prescription", chevronColor: Color("NHSAppDarkPurple").opacity(0.7)) { }
                    }
                    .rowStyle(.palePurple)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Appointment card (example)
                Section {
                    RowLink(chevronColor: Color("NHSAppDarkAquaGreen")) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Upcoming appointment")
                                .bold()
                                .padding(.bottom, 4)
                            Text("Tuesday, 15 November 2025")
                                .font(.subheadline)
                            Text("3:15pm")
                                .font(.subheadline)
                                .padding(.bottom, 8)
                            Text("Dr Conor Murphy")
                                .font(.subheadline)
                            Text("Menston Medical Centre")
                                .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                    } destination: { }
                }
                .rowStyle(.paleAquaGreen)
                

                // Navigation links
                Section {
                    RowLink(title: "Prescriptions") { }
                    RowLink(title: "Appointments") { }
                    RowLink(title: "Test results") { }
                    RowLink(title: "Vaccinations") { }
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
            .fullScreenCover(item: $selectedLink) { link in
                SafariView(url: link.url)
                    .ignoresSafeArea()
            }
            .nhsListStyle()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("App help") {
                        print("App help tapped")
                    }
                }
            }
        }
        .background(Color.pageBackground)
        .onAppear {
            // Only schedule the intro animation if:
            // 1) The card isn’t permanently hidden, and
            // 2) We haven’t scheduled it already in this session.
            guard !hidePrescriptionCard, !didScheduleIntro else { return }
            didScheduleIntro = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showPrescriptionCard = true
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
