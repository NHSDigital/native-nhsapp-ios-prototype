import SwiftUI

struct SplashView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            Color("NHSBlue").ignoresSafeArea()

            Image("nhs_logo") // same asset as Launch Screen
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .onAppear {
            if reduceMotion {
                opacity = 1
                scale = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    onFinish()
                }
            } else {
                // 👇 Delay the logo animation slightly (e.g. 0.4 seconds)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.easeOut(duration: 1)) {
                        opacity = 1
                    }
                    withAnimation(.spring(response: 0.7, dampingFraction: 0.6, blendDuration: 0)) {
                        scale = 1.0
                    }
                }

                // Keep total splash time about 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    onFinish()
                }
            }
        }
    }
}

#Preview {
    SplashView {
        // no-op for preview
    }
}
