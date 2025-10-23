import SwiftUI

struct HealthConditionsViewV1: View {

    var body: some View {
        List {

            Section {
                NavigationLink("Allergies and adverse reactions") {
                    DetailView(index: 0)
                }
                NavigationLink("All conditions") {
                    DetailView(index: 0)
                }
            }
            .rowStyle(.white)

        }
        .navigationTitle("Health conditions")
        .navigationBarTitleDisplayMode(.large)
        .nhsListStyle()
    }
}

#Preview {
    NavigationStack {
        HealthConditionsViewV1()
    }
}
