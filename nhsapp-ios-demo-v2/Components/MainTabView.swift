import SwiftUI

struct MainTabView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }

            MessagesView()
                .tabItem {
                    VStack {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                        Text("Messages")
                    }
                }

            ProfileView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
                }
        }
    }

}

#Preview {
    MainTabView()
}
