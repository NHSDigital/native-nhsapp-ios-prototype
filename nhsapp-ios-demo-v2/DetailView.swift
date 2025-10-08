import SwiftUI

struct DetailView: View {
    let index: Int
    var body: some View {
        Text("Detail View \(index + 1)")
            .font(.title)
            .navigationTitle("Detail \(index + 1)")
    }
}
