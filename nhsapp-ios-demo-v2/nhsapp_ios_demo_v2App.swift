import SwiftUI

@main
struct NHSApp_iOS_Demo_v2App: App {
    @StateObject private var externalLinks = ExternalLinkManager()
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
            // ✅ Move modifiers *outside* the ZStack
            .environmentObject(externalLinks)
            .externalLinkPresenter()
        }
    }
}

#Preview("App Flow – Runs Splash") {
    AppFlowPreview()
        .environmentObject(ExternalLinkManager())
}
