import SwiftUI

struct DocumentsView: View {

    var body: some View {
        List {

            Section {
                RowLink(title: "GP documents") { DetailView(index: 0) }
            } header: {
                Text("GP surgery")
            }
            .rowStyle(.white)
            
            Section {
                RowLink(title: "Hospital and specialist documents and questionnaires") { DetailView(index: 0) }
                RowLink(title: "Useful links from your health team") { DetailView(index: 0) }
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
    DocumentsView()
}
