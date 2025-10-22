import SwiftUI

struct AppFlowPreview: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            // Edit this to change the nav for the different versions
            MainTabView()
                .opacity(showSplash ? 0 : 1)

            if showSplash {
                SplashView {
                    withAnimation(.easeOut(duration: 0.8)) {
                        showSplash = false
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

#Preview("App Flow – Runs Splash") {
    AppFlowPreview()
}
