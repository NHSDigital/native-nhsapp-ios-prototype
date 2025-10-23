import SwiftUI

extension View {
    /// Adds a toolbar button labeled "App help" to the top-right of the navigation bar.
    func appHelpToolbar() -> some View {
        self.toolbar {
            // NHS Logo
            ToolbarItem(placement: .principal) {
                Image("nhs_logo_blue")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
            }
            // Help button
            ToolbarItem(placement: .topBarTrailing) {
                Button("App help") {}
            }
        }
    }
}
