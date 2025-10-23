import SwiftUI

struct ProfileViewV1: View {

    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("David Hunter")
                                .font(.title2)
                                .bold()

                            Text("Date of birth: 15 March 1984")
                                .foregroundStyle(.textSecondary)
                            
                            Text("NHS number: 123 456 789")
                                .foregroundStyle(.textSecondary)
                        }
                    }
                    .padding(.vertical, 4)
                    NavigationLink("Manage health services for others", destination: DetailView(index: 0))
                }
                .rowStyle(.white)
                
                Section(header: Text("Personal details")) {
                    NavigationLink("Contact details", destination: DetailView(index: 0))
                    NavigationLink("Your GP surgery", destination: DetailView(index: 0))
                    NavigationLink("Health choices", destination: DetailView(index: 0))
                    NavigationLink("Care plans", destination: DetailView(index: 0))
                }
                .rowStyle(.white)
                
                Section(header: Text("App settings")) {
                    NavigationLink("Face ID", destination: DetailView(index: 0))
                    NavigationLink("Login and security", destination: DetailView(index: 0))
                    NavigationLink("Notifications", destination: DetailView(index: 0))
                    NavigationLink("Cookies", destination: DetailView(index: 0))
                }
                .rowStyle(.white)
                
                Section(header: Text("About the NHS App")) {
                    NavigationLink("Privacy and legal policies", destination: DetailView(index: 0))
                    NavigationLink("Join our user research panel", destination: DetailView(index: 0))
                }
                .rowStyle(.white)
                
                Section {
                    Button("Log out", role: .destructive) { }
                }
                .rowStyle(.white)

            }
            .nhsListStyle()
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .appHelpToolbar()
            .background(Color.pageBackground)
        }
    }
}

#Preview {
    ProfileViewV1()
}
