import SwiftUI

struct HomeView: View {

    // Use an Identifiable item so the cover only shows when non-nil
    struct LinkItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let url: URL
    }

    @State private var selectedLink: LinkItem? = nil
    
    @AccessibilityFocusState private var isSafariFocused: Bool

    // State variables for toggle examples
    @State private var toggleOne = true
    @State private var toggleTwo = false
    
    // Start hidden so we can animate it in after a delay
    @State private var showPrescriptionCard = false
    
    @State private var showAppointmentCard = false

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
                                .padding(.bottom, 12)
                            
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
                    .padding(.bottom, -8)
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            print("Change user tapped")
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 14)) // smaller icon
                                    .bold()
                                    .accessibilityHidden(true)
                                Text("Change profile")
                                    .font(.subheadline)
                                    .bold()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color("NHSAppDarkBlueOnly").opacity(0.6))
                            .foregroundColor(.textInverseOnly)
                            .clipShape(Capsule())
                        }
                        
                        Button(action: {
                            print("Add user tapped")
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .font(.system(size: 14)) // smaller icon
                                    .bold()
                                    .accessibilityHidden(true)
                                Text("Add person")
                                    .font(.subheadline)
                                    .bold()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color("NHSAppDarkBlueOnly").opacity(0.6))
                            .foregroundColor(.textInverseOnly)
                            .clipShape(Capsule())
                        }
                    }
                }
                .rowStyle(.blue)
                
                // Prescription card (no persistence; shows after delay on each appearance)
                if showPrescriptionCard {
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
                                    showPrescriptionCard = false
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Color("NHSAppDarkPurple"))
                                    .accessibilityLabel("Dismiss prescription card")
                            }
                            .accessibilityLabel("Dismiss prescription card")
                            .accessibilityHint("Hides the ‘Ready to collect’ message.")
                            
                        }
                        RowLink(title: "View prescription", chevronColor: Color("NHSAppDarkPurple").opacity(0.7)) { }
                    }
                    .rowStyle(.palePurple)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                if showAppointmentCard {
                    // Appointment card (example)
                    Section {
                        RowLink {
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
                                    .foregroundColor(.textSecondary)
                                Text("Menston Medical Centre")
                                    .font(.subheadline)
                                    .foregroundColor(.textSecondary)
                            }
                            .padding(.vertical, 4)
                        } destination: { }
                    }
                    .rowStyle(.white)
                }
                

                // Navigation links
                Section {
                    RowLink {
                        Label {
                            Text("Prescriptions")
                                .foregroundColor(.text)
                        } icon: {
                            Image(systemName: "pills.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color("NHSPurple"))
                                .padding(8)
                                .background(Color("NHSAppPalePurple"))
                                .clipShape(Circle())
                        }
                    } destination: { }

                    RowLink {
                        Label {
                            Text("Appointments")
                                .foregroundColor(.text)
                        } icon: {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 12))
                                .foregroundColor(.accentColor)
                                .padding(8)
                                .background(Color("NHSAppPaleBlue"))
                                .clipShape(Circle())
                        }
                    } destination: { }

                    RowLink {
                        Label {
                            Text("Test results")
                                .foregroundColor(.text)
                        } icon: {
                            Image(systemName: "waveform.path.ecg")
                                .font(.system(size: 12))
                                .foregroundColor(Color("NHSPink"))
                                .padding(8)
                                .background(Color("NHSAppPalePink"))
                                .clipShape(Circle())
                        }
                    } destination: { }

                    RowLink {
                        Label {
                            Text("Vaccinations")
                                .foregroundColor(.text)
                        } icon: {
                            Image(systemName: "syringe")
                                .font(.system(size: 12))
                                .foregroundColor(Color("NHSOrange"))
                                .padding(8)
                                .background(Color("NHSAppPaleOrange"))
                                .clipShape(Circle())
                        }
                    } destination: { }

                    RowLink {
                        Label {
                            Text("Health conditions")
                                .foregroundColor(.text)
                        } icon: {
                            Image(systemName: "cross.case.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color("NHSAquaGreen"))
                                .padding(8)
                                .background(Color("NHSAppPaleAquaGreen"))
                                .clipShape(Circle())
                        }
                    } destination: { }

                    RowLink {
                        Label {
                            Text("Documents")
                                .foregroundColor(.text)
                        } icon: {
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color("NHSRed"))
                                .padding(8)
                                .background(Color("NHSAppPaleRed"))
                                .clipShape(Circle())
                        }
                    } destination: { }
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
                .accessibilityFocused($isSafariFocused)
                .onAppear { isSafariFocused = true }
            }
            .nhsListStyle()
        }
        .background(Color.pageBackground)
        .onAppear {
            // Re-schedule every time HomeView appears
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
