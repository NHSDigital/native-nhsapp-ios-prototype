import SwiftUI

struct DocumentsViewV1: View {

    var body: some View {
        List {

            Section {
                NavigationLink("GP documents") {
                    DetailView(index: 0)
                }
            } header: {
                Text("GP surgery")
            }
            .rowStyle(.white)
            
            Section {
                NavigationLink("Hospital and specialist documents and questionnaires") {
                    DetailView(index: 0)
                }
                NavigationLink("Useful links from your health team") {
                    DetailView(index: 0)
                }
            } header: {
                Text("Hospital")
            }
            .rowStyle(.white)

        }
        .navigationTitle("Documents")
        .navigationBarTitleDisplayMode(.large)
        .nhsListStyle()
    }
}

#Preview {
    NavigationStack {
        DocumentsViewV1()
    }
}
