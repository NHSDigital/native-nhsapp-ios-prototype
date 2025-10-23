import SwiftUI

struct MainTabViewV1: View {
    @State private var selection = 0
    // Uses the V1 store since MessagesViewV1
    @StateObject private var messageStoreV1 = MessageStoreV1()

    var body: some View {
        TabView(selection: $selection) {
            HomeViewV1()
                .tag(0)
                .tabItem {
                    Group { Label("Home", systemImage: "house") }
                        .environment(\.symbolVariants, selection == 0 ? .fill : .none)
                }

            MessagesViewV1()
                .environmentObject(messageStoreV1)
                .tag(1)
                .badge(messageStoreV1.unreadCount)
                .tabItem {
                    Group { Label("Messages", systemImage: "bubble.left.and.bubble.right") }
                        .environment(\.symbolVariants, selection == 1 ? .fill : .none)
                }

            ProfileViewV1()
                .tag(2)
                .tabItem {
                    Group { Label("Profile", systemImage: "person.crop.circle") }
                        .environment(\.symbolVariants, selection == 2 ? .fill : .none)
                }
        }
    }
}

#Preview {
    MainTabViewV1()
        .environmentObject(MessageStoreV1())
}
