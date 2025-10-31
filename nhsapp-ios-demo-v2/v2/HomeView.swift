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
    
    @State private var showAppointmentCard = true
    
    @State private var isNavigated = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            NavigationStack {
                List {
                
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
                                .accessibilityHint("Hides the 'Ready to collect' message.")
                                
                            }
                            RowLink(title: "View prescription", chevronColor: Color("NHSAppDarkPurple").opacity(0.7)) { DetailView(index: 0) }
                        }
                        .rowStyle(.palePurple)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                
    //                if showAppointmentCard {
    //                    // Appointment card (example)
    //                    Section {
    //                        RowLink {
    //                            VStack(alignment: .leading, spacing: 4) {
    //                                Text("Upcoming appointment")
    //                                    .bold()
    //                                    .padding(.bottom, 4)
    //                                Text("Tuesday, 15 November 2025")
    //                                    .font(.subheadline)
    //                                Text("3:15pm")
    //                                    .font(.subheadline)
    //                                    .padding(.bottom, 8)
    //                                Text("Dr Conor Murphy")
    //                                    .font(.subheadline)
    //                                Text("Menston Medical Centre")
    //                                    .font(.subheadline)
    //                            }
    //                            .padding(.vertical, 4)
    //                        } destination: { DetailView(index: 0) }
    //                    }
    //                    .rowStyle(.paleBlue)
    //                }
                

                    // Navigation links
                    Section {
                        RowLink {
                            Label {
                                Text("Prescriptions")
                                    .foregroundColor(.text)
                            } icon: {
                                Image(systemName: "pills.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.white)
                                    .padding(8)
                                    .background(Color("NHSPurple"))
                                    .clipShape(Circle())
                            }
                        } destination: { PrescriptionsView() }

                        RowLink {
                            Label {
                                Text("Appointments")
                                    .foregroundColor(.text)
                            } icon: {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.white)
                                    .padding(8)
                                    .background(Color("NHSBlue"))
                                    .clipShape(Circle())
                            }
                        } destination: { AppointmentsView() }

                        RowLink {
                            Label {
                                Text("Test results")
                                    .foregroundColor(.text)
                            } icon: {
                                Image(systemName: "waveform.path.ecg")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.white)
                                    .padding(8)
                                    .background(Color("NHSPink"))
                                    .clipShape(Circle())
                            }
                        } destination: { TestResultsView() }

                        RowLink {
                            Label {
                                Text("Vaccinations")
                                    .foregroundColor(.text)
                            } icon: {
                                Image(systemName: "syringe")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.white)
                                    .padding(8)
                                    .background(Color("NHSOrange"))
                                    .clipShape(Circle())
                            }
                        } destination: { VaccinationsView() }

                        RowLink {
                            Label {
                                Text("Health conditions")
                                    .foregroundColor(.text)
                            } icon: {
                                Image(systemName: "cross.case.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.white)
                                    .padding(8)
                                    .background(Color("NHSGreen"))
                                    .clipShape(Circle())
                            }
                        } destination: { HealthConditionsView() }

                        RowLink {
                            Label {
                                Text("Documents")
                                    .foregroundColor(.text)
                            } icon: {
                                Image(systemName: "doc.text.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.white)
                                    .padding(8)
                                    .background(Color("NHSRed"))
                                    .clipShape(Circle())
                            }
                        } destination: { DocumentsView() }
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
                    
                    // Campaign card
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
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.large)
                .fullScreenCover(item: $selectedLink) { link in
                  SafariView(url: link.url)
                    .ignoresSafeArea()
                    .accessibilityFocused($isSafariFocused)
                    .onAppear { isSafariFocused = true }
                }
                .nhsListStyle()
                .background(Color.pageBackground)
                .environment(\.isNavigated, $isNavigated)
                .onAppear {
                    isNavigated = false
                    // Re-schedule every time HomeView appears
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showPrescriptionCard = true
                        }
                    }
                }
            }
            
            // Logo - outside NavigationStack, only visible when not navigated
            if !isNavigated {
                Image("nhs_logo_blue")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28)
                    .accessibilityLabel("NHS")
                    .padding(.leading, 16)
                    .padding(.top, 8)
                    .allowsHitTesting(false)
            }
        }
    }
}

#Preview { MainTabView() }

