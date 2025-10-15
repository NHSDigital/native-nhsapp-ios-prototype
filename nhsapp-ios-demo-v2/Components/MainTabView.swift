import SwiftUI

struct MainTabView: View {
    
    @State private var selection = 0
    @StateObject private var messageStore = MessageStore()

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tag(0)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            MessagesView()
                .environmentObject(messageStore)
                .tag(1)
                .badge(messageStore.unreadCount)
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Messages")
                }

            ProfileView()
                .tag(2)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    MainTabView()
}
