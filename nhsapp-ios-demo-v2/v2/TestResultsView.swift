import SwiftUI

struct TestResultsView: View {

    var body: some View {
        List {

            Section {
                RowLink(title: "GP-ordered test results") { DetailView(index: 0) }
            } header: {
                Text("GP surgery")
            }
            .rowStyle(.white)
            
            Section {
                RowLink(title: "Hospital-ordered test results") { DetailView(index: 0) }
            } header: {
                Text("Hospital")
            }
            .rowStyle(.white)

        }
        .navigationTitle("Test results")
        .navigationBarTitleDisplayMode(.large)
        .nhsListStyle()
    }
}

#Preview {
    TestResultsView()
}
