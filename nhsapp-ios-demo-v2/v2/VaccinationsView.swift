import SwiftUI

struct VaccinationsView: View {

    var body: some View {
        List {

            Section {
                RowLink(title: "Book or read about vaccinations") { DetailView(index: 0) }
                RowLink(title: "Your vaccinations") { DetailView(index: 0) }
                RowLink(title: "COVID-19 vaccinations") { DetailView(index: 0) }
            }
            .rowStyle(.white)

        }
        .navigationTitle("Vaccinations")
        .navigationBarTitleDisplayMode(.large)
        .nhsListStyle()
    }
}

#Preview {
    VaccinationsView()
}
