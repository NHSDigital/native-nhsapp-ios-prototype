import SwiftUI

struct PrescriptionsViewV1: View {

    var body: some View {
        List {
            
            Section {
                NavigationLink("Request a repeat prescription") {
                    DetailView(index: 0)
                }
                NavigationLink("Check the progress of prescriptions") {
                    DetailView(index: 0)
                }
                NavigationLink("Medicines record") {
                    DetailView(index: 0)
                }
                NavigationLink("Request an emergency prescription") {
                    DetailView(index: 0)
                }
                NavigationLink {
                    DetailView(index: 0)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your chosen pharmacy")
                        Text("Wellcare Pharmacy")
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
                NavigationLink("Hospital and other medicines") {
                    DetailView(index: 0)
                }
            } header: {
                Text("Hospital")
            }
            .rowStyle(.white)

        }
        .navigationTitle("Prescriptions")
        .navigationBarTitleDisplayMode(.large)
        .nhsListStyle()
    }
}

#Preview {
    NavigationStack {
        PrescriptionsViewV1()
    }
}
