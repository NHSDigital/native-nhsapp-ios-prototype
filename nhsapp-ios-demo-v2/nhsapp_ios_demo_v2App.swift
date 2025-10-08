import SwiftUI

@main
struct NHSApp_iOS_Demo_v2App: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
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
}

#Preview("App Flow – Runs Splash") {
    AppFlowPreview()
}
