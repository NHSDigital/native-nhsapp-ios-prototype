import SwiftUI

struct MainTabView: View {
    @StateObject private var messageStore = MessageStore()

    var body: some View {
        HomeView()
            .environmentObject(messageStore)
    }
}

#Preview { MainTabView() }
