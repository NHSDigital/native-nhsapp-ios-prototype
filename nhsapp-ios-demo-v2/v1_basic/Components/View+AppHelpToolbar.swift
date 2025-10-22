import SwiftUI

extension View {
    /// Adds a toolbar button labeled "App help" to the top-right of the navigation bar.
    func appHelpToolbar() -> some View {
        self.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("App help") {
                    // No action yet
                }
            }
        }
    }
}
