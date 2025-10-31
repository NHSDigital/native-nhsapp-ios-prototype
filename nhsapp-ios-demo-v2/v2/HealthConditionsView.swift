import SwiftUI

struct HealthConditionsView: View {
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
                RowLink(title: "Allergies and adverse reactions") { DetailView(index: 0) }
                RowLink(title: "All conditions") { DetailView(index: 0) }
            }
            .rowStyle(.white)

        }
        .navigationTitle("Health conditions")
        .navigationBarTitleDisplayMode(.large)
        .nhsListStyle()
    }
}

#Preview {
    HealthConditionsView(activeProfile: .self_)
}
