import SwiftUI

struct TestResultsView: View {
    let activeProfile: ProfileOption

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
    TestResultsView(activeProfile: .self_)
}
