import SwiftUI

struct AppointmentsFlowRoot: View {
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
            AppointmentsBookStartView()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { isPresented = false }) {
                            Image(systemName: "xmark")
                                .imageScale(.large)
                                .foregroundColor(.black)
                                .accessibilityLabel("Close")
                        }
                    }
                }
        }
    }
}

#Preview {
    AppointmentsView(activeProfile: .self_)
}
