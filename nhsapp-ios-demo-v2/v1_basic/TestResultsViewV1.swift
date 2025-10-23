import SwiftUI

struct TestResultsViewV1: View {

    var body: some View {
        List {

            Section {
                NavigationLink("GP-ordered test results") {
                    DetailView(index: 0)
                }
            } header: {
                Text("GP surgery")
            }
            .rowStyle(.white)
            
            Section {
                NavigationLink("Hospital-ordered test results") {
                    DetailView(index: 0)
                }
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
    NavigationStack {
        TestResultsViewV1()
    }
}
