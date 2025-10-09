import SwiftUI

@main
struct NHSApp_iOS_Demo_v2App: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashView {
                        withAnimation(.easeOut(duration: 0.8)) {
                            showSplash = false
                        }
                    }
                    .ignoresSafeArea()
                    .transition(.opacity)
                } else {
                    MainTabView()
                        .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.8), value: showSplash)
        }
    }
}

#Preview("App Flow – Runs Splash") {
    AppFlowPreview()
}
