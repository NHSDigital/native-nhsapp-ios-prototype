import SwiftUI

struct MainTabViewV1: View {
    @State private var selection = 0
    @StateObject private var messageStore = MessageStore()

    var body: some View {
        TabView(selection: $selection) {
            HomeViewV1()
                .tag(0)
                .tabItem {
                    Group {
                        Label("Home", systemImage: "house")
                    }
                    .environment(\.symbolVariants, selection == 0 ? .fill : .none)
                }

            MessagesViewV1()
                .environmentObject(messageStore)
                .tag(1)
                .badge(messageStore.unreadCount)
                .tabItem {
                    Group {
                        Label("Messages", systemImage: "bubble.left.and.bubble.right")
                    }
                    .environment(\.symbolVariants, selection == 1 ? .fill : .none)
                }

            ProfileViewV1()
                .tag(2)
                .tabItem {
                    Group {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    .environment(\.symbolVariants, selection == 2 ? .fill : .none)
                }
        }
    }
}

#Preview { MainTabViewV1() }

