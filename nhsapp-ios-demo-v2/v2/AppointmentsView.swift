import SwiftUI

struct AppointmentsView: View {
    @State private var showAppointmentsSheet = false

    var body: some View {
        List {

            Section {
                // Custom row that looks like RowLink but opens a sheet
                HStack {
                    Text("Book an appointment")
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
                
                RowLink(title: "Manage GP appointments") { DetailView(index: 0) }
                RowLink(title: "Appointment notes and other updates") { DetailView(index: 0) }
                RowLink {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Request a letter or information")
                        Text("Provided using Accurx")
                            .font(.subheadline)
                            .foregroundStyle(.textSecondary)
                    }
                    .padding(.vertical, 4)
                } destination: {
                    DetailView(index: 0)
                }
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
        .sheet(isPresented: $showAppointmentsSheet) {
            AppointmentsFlowRoot(isPresented: $showAppointmentsSheet)
        }

    }
}

#Preview {
    AppointmentsView()
}
