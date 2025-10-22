import SwiftUI

struct AppointmentsView: View {

    var body: some View {
        List {

            Section {
                RowLink(title: "Book an appointment") { DetailView(index: 0) }
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
        .nhsListStyle()
    }
}

#Preview {
    AppointmentsView()
}
