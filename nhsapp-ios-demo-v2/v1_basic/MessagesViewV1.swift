import SwiftUI

struct MessagesViewV1: View {

    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    NavigationLink("Profile", destination: DetailView(index: 0))
                    NavigationLink("Settings", destination: DetailView(index: 0))
                    NavigationLink("Help", destination: DetailView(index: 0))
                }
                .rowStyle(.white)

            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.pageBackground)
            .appHelpToolbar()
        }
    }
}

#Preview {
    MessagesViewV1()
}
