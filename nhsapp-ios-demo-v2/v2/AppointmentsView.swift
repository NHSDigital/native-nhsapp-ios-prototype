import SwiftUI

struct AppointmentsView: View {
    let activeProfile: ProfileOption
    
    @State private var showAppointmentsSheet = false
    @State private var showBookingFlow = false
    
    @Environment(\.isNavigated) private var isNavigated

    var body: some View {
        List {
            
            // Acting for banner
            if activeProfile != .self_ {
                Section {
                    ActingForBanner(profile: activeProfile)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
            }
            
            Section {
                // Book an appointment - navigates to embedded flow
                Button(action: {
                    showBookingFlow = true
                    isNavigated.wrappedValue = true
                }) {
                    HStack {
                        Text("Book an appointment")
                            .foregroundColor(.nhsBlack)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.accentColor.opacity(0.7))
                    }
                }
                .buttonStyle(.plain)
                
                RowLink(title: "Manage GP appointments") { DetailView(index: 0) }
                RowLink(title: "Appointment notes and other updates") { DetailView(index: 0) }
                
                // Request a letter - now opens sheet
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Request a letter or information")
                        Text("Provided using Accurx")
                            .font(.subheadline)
                            .foregroundStyle(.textSecondary)
                    }
                    .padding(.vertical, 4)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.accentColor.opacity(0.7))
                        .accessibilityHidden(true)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    showAppointmentsSheet = true
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(.isButton)
            } header: {
                Text("GP surgery")
            }
            .rowStyle(.white)
            
            Section {
                RowLink(title: "Manage hospital and specialist appointments") { DetailView(index: 0) }
                RowLink(title: "Referrals") { DetailView(index: 0) }
                RowLink(title: "Waiting lists") { DetailView(index: 0) }
            } header: {
                Text("Hospital")
            }
            .rowStyle(.white)
        }
        .navigationTitle("Appointments")
        .navigationBarTitleDisplayMode(.large)
        .nhsListStyle()
        .navigationDestination(isPresented: $showBookingFlow) {
            BookingEmbeddedStep1View()
                .environment(\.dismissToRoot, {
                    showBookingFlow = false
                })
                .onAppear {
                    isNavigated.wrappedValue = true
                }
        }
        .sheet(isPresented: $showAppointmentsSheet) {
            BookingFlowCoordinator()
        }
    }
}

#Preview {
    NavigationStack {
        AppointmentsView(activeProfile: .self_)
    }
}
