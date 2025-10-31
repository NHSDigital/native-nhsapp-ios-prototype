import SwiftUI

struct ProfileView: View {
    let profile: ProfileOption
    
    var body: some View {
        NavigationStack {
            List {

                // Custom row with title, subtitle and a navigation link
                Section {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            VStack(alignment: .leading){
                                Text("Acting for:")
                                    .font(.body)
                                    .bold()
                                Text(profile.name)
                                    .font(.title2)
                                    .bold()
                            }
                            .padding(.bottom, 10)
                               
                            Text("Date of birth: 15 March 1984")
                                .font(.subheadline)
                            Text("NHS number: \(profile.nhsNumber)")
                                .font(.subheadline)
                        }
                        .foregroundColor(Color.nhsWhite)
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 8)
                    
                }
                .listRowBackground(profile.backgroundColor)
                .rowStyle(.white)
                
                Section {
                    RowLink(title: "Contact details") { DetailView(index: 0) }
                    RowLink(title: "Your GP surgery") { DetailView(index: 0) }
                    RowLink(title: "Health choices") { DetailView(index: 0) }
                    RowLink(title: "Care plans") { DetailView(index: 0) }
                } header: {
                    Text("Personal details")
                }
                .rowStyle(.white)
                
                Section {
                    RowLink(title: "Face ID") { DetailView(index: 0) }
                    RowLink(title: "Login and security") { DetailView(index: 0) }
                    RowLink(title: "Notifications") { DetailView(index: 0) }
                    RowLink(title: "Cookies") { DetailView(index: 0) }
                } header: {
                    Text("App settings")
                }
                .rowStyle(.white)
                
                Section {
                    RowLink(title: "Privacy and legal policies") { DetailView(index: 0) }
                    RowLink(title: "Join our research panel") { DetailView(index: 0) }
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
            .navigationBarTitleDisplayMode(.large)
            .nhsListStyle()
        }
        .background(Color.pageBackground)
    }
}


#Preview {
    ProfileView(profile: .self_)
}
