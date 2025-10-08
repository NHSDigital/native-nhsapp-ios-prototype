import SwiftUI

struct SplashView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            Color("BrandBackground").ignoresSafeArea()

            Image("AppLogo") // same asset as Launch Screen
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .onAppear {
            if reduceMotion {
                // Respect Reduce Motion: no bouncy animation
                opacity = 1
                scale = 1
                // Keep the timing short so it doesn’t feel like a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    onFinish()
                }
            } else {
                withAnimation(.easeOut(duration: 0.45)) { opacity = 1 }
                withAnimation(.spring(response: 0.7, dampingFraction: 0.6, blendDuration: 0)) {
                    scale = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                    onFinish()
                }
            }
        }
    }
}
