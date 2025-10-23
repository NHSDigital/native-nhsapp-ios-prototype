import SwiftUI

struct VaccinationsViewV1: View {

    var body: some View {
        List {

            Section {
                NavigationLink("Book or read about vaccinations") {
                    DetailView(index: 0)
                }
                NavigationLink("Your vaccinations") {
                    DetailView(index: 0)
                }
                NavigationLink("COVID-19 vaccinations") {
                    DetailView(index: 0)
                }
            }
            .rowStyle(.white)

        }
        .navigationTitle("Vaccinations")
        .navigationBarTitleDisplayMode(.large)
        .nhsListStyle()
    }
}

#Preview {
    NavigationStack {
        VaccinationsViewV1()
    }
}
