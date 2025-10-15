import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {

                // Custom row with title, subtitle and a navigation link
                Section {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("David Hunter")
                                .font(.title)
                                .bold()
                            Text("Date of birth: 15 March 1984")
                                .font(.subheadline)
                            Text("NHS number: 123 456 789")
                                .font(.subheadline)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    RowLink(title: "Manage health services for others", chevronColor: Color("NHSAppDarkBlue").opacity(0.7)) {
                            DetailView(index: 6)
                        }
    
                }
                .rowStyle(.paleBlue)
                
                Section {
                    RowLink(title: "Contact details") { }
                    RowLink(title: "Your GP surgery") { }
                    RowLink(title: "Health choices") { }
                    RowLink(title: "Care plans") { }
                } header: {
                    Text("Personal details")
                }
                .rowStyle(.white)
                
                Section {
                    RowLink(title: "Face ID") { }
                    RowLink(title: "Login and security") { }
                    RowLink(title: "Notifications") { }
                    RowLink(title: "Cookies") { }
                } header: {
                    Text("App settings")
                }
                .rowStyle(.white)
                
                Section {
                    RowLink(title: "Privacy and legal policies") { }
                    RowLink(title: "Join our research panel") { }
                } header: {
                    Text("About the NHS App")
                }
                .rowStyle(.white)
                
                Section {
                    Button("Log out", role: .destructive) { }
                } footer: {
                    Text("Version 2.36.6 (2.36.0)")
                        .foregroundStyle(.textSecondary)
                }
                .rowStyle(.white)

            }
            .navigationTitle("Profile")
            .nhsListStyle()
        }
        .background(Color.pageBackground)
    }
}


#Preview {
    ProfileView()
}
