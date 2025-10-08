import SwiftUI

struct AppPreview: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            ContentView()
                .opacity(showSplash ? 0 : 1)

            if showSplash {
                SplashView {
                    withAnimation(.easeOut(duration: 0.35)) {
                        showSplash = false
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

#Preview("App Flow – Runs Splash") {
    AppPreview()
}

#Preview("App Flow – Post Splash (Dark)") {
    AppPreview()
        .preferredColorScheme(.dark)
}
