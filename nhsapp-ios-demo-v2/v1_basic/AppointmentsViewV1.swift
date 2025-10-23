import SwiftUI

struct AppointmentsViewV1: View {

    var body: some View {
        List {

            Section {
                NavigationLink("Book an appointment") {
                    DetailView(index: 0)
                }
                NavigationLink("Manage GP appointments") {
                    DetailView(index: 0)
                }
                NavigationLink("Appointment notes and other updates") {
                    DetailView(index: 0)
                }
                NavigationLink {
                    DetailView(index: 0)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Request a letter or information")
                        Text("Provided using Accurx")
                            .font(.subheadline)
                            .foregroundStyle(.textSecondary)
                    }
                    .padding(.vertical, 4)
                }
            } header: {
                Text("GP surgery")
            }
            .rowStyle(.white)
            
            Section {
                NavigationLink("Manage hospital and specialist appointments") {
                    DetailView(index: 0)
                }
                NavigationLink("Referrals") {
                    DetailView(index: 0)
                }
                NavigationLink("Waiting lists") {
                    DetailView(index: 0)
                }
            } header: {
                Text("Hospital")
            }
            .rowStyle(.white)

        }
        .navigationTitle("Appointments")
        .navigationBarTitleDisplayMode(.large)
        .nhsListStyle()
    }
}

#Preview {
    NavigationStack {
        AppointmentsViewV1()
    }
}
