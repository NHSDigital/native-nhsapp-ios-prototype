import SwiftUI

struct HomeView: View {
    
    struct LinkItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let url: URL
    }
    
    // Profile options
    enum ProfileOption: String, CaseIterable, Identifiable {
        case self_ = "Yourself"
        case spouse = "Spouse"
        case child = "Child"
        
        var id: String { self.rawValue }
        
        var name: String {
            switch self {
            case .self_: return "Shivaya Patel-Jones"
            case .spouse: return "Alex Patel-Jones"
            case .child: return "Maya Patel-Jones"
            }
        }
        
        var nhsNumber: String {
            switch self {
            case .self_: return "123 567 890"
            case .spouse: return "234 678 901"
            case .child: return "345 789 012"
            }
        }
        
        var age: String {
            switch self {
            case .self_: return "46 years old (you)"
            case .spouse: return "44 years old (your spouse)"
            case .child: return "12 years old (your child)"
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .self_: return Color("NHSBlue")
            case .spouse: return Color("NHSPurple")
            case .child: return Color("NHSGreen")
            }
        }
        
        var messageCount: Int {
            switch self {
            case .self_: return 3
            case .spouse: return 1
            case .child: return 5
            }
        }
    }

    @State private var selectedLink: LinkItem? = nil
    @AccessibilityFocusState private var isSafariFocused: Bool
    @State private var showProfileSheet = false
    @State private var activeProfile: ProfileOption = .self_
    @State private var tempSelectedProfile: ProfileOption = .self_
    @EnvironmentObject var messageStore: MessageStore

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: - The page header
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .center) {
                            Image("nhs_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 28)
                                .accessibilityLabel("NHS")
                            
                            Spacer()
                            
                            // Messages button with badge
                            NavigationLink(destination: MessagesView().environmentObject(messageStore)) {
                                ZStack(alignment: .topTrailing) {
                                    Image(systemName: "envelope.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color.clear)
                                        .overlay(Circle().stroke(Color.white.opacity(0.5), lineWidth: 1.5))
                                        .clipShape(Circle())
                                    
                                    // Badge with message count
                                    if activeProfile.messageCount > 0 {
                                        Text("\(activeProfile.messageCount)")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(minWidth: 18, minHeight: 18)
                                            .background(Color.red)
                                            .clipShape(Circle())
                                            .offset(x: 6, y: -2)
                                    }
                                }
                            }
                        }
                        
                        Text(activeProfile.name)
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("NHS number: \(activeProfile.nhsNumber)")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text(activeProfile.age)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                tempSelectedProfile = activeProfile
                                showProfileSheet = true
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .font(.system(size: 16))
                                        .bold()
                                        .accessibilityHidden(true)
                                    Text("Switch profiles")
                                        .font(.subheadline)
                                        .bold()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.clear)
                                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.5), lineWidth: 1.5))
                                    .foregroundColor(.textInverseOnly)
                                .clipShape(Capsule())
                            }
                            .padding(.top, 10)
                            
                            NavigationLink(destination: ProfileView()) {
                                HStack(spacing: 6) {
                                    Image(systemName: "person.crop.circle")
                                        .font(.system(size: 16))
                                        .bold()
                                        .accessibilityHidden(true)
                                    Text("Profile")
                                        .font(.subheadline)
                                        .bold()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.clear)
                                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.5), lineWidth: 1.5))
                                    .foregroundColor(.textInverseOnly)
                                .clipShape(Capsule())
                            }
                            .padding(.top, 10)
                        }
                        
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 68)
                    .padding(.bottom, 30)
                    .background(
                        GeometryReader { geometry in
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    activeProfile.backgroundColor,
                                    activeProfile.backgroundColor,
                                    activeProfile.backgroundColor,
                                    activeProfile.backgroundColor.opacity(0.9),
                                    activeProfile.backgroundColor.opacity(0.8)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(width: geometry.size.width, height: geometry.size.height + max(0, -geometry.frame(in: .global).minY))
                            .offset(y: min(0, geometry.frame(in: .global).minY))
                        }
                    )
                    
// MARK: - Navigation links section
                    VStack(spacing: 0) {
                        NavigationLink(destination: PrescriptionsView()) {
                            HStack(spacing: 10) {
                                Image(systemName: "pills.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(.white))
                                    .padding(10)
                                    .background(Color("NHSPurple"))
                                    .clipShape(Circle())
                                
                                Text("Prescriptions")
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 16)
                            .padding(.vertical, 10)
                        }
                        
                        Divider()
                            .padding(.leading, 62)
                            .padding(.trailing, 16)
                        
                        NavigationLink(destination: AppointmentsView()) {
                            HStack(spacing: 10) {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color("NHSBlue"))
                                    .clipShape(Circle())
                                
                                Text("Appointments")
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 16)
                            .padding(.vertical, 10)
                        }
                        
                        Divider()
                            .padding(.leading, 62)
                            .padding(.trailing, 16)
                        
                        NavigationLink(destination: TestResultsView()) {
                            HStack(spacing: 10) {
                                Image(systemName: "waveform.path.ecg")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color("NHSPink"))
                                    .clipShape(Circle())
                                
                                Text("Test results")
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 16)
                            .padding(.vertical, 10)
                        }
                        
                        Divider()
                            .padding(.leading, 62)
                            .padding(.trailing, 16)
                        
                        NavigationLink(destination: VaccinationsView()) {
                            HStack(spacing: 10) {
                                Image(systemName: "syringe")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color("NHSOrange"))
                                    .clipShape(Circle())
                                
                                Text("Vaccinations")
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 16)
                            .padding(.vertical, 10)
                        }
                        
                        Divider()
                            .padding(.leading, 62)
                            .padding(.trailing, 16)
                        
                        NavigationLink(destination: HealthConditionsView()) {
                            HStack(spacing: 10) {
                                Image(systemName: "cross.case.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color("NHSGreen"))
                                    .clipShape(Circle())
                                
                                Text("Health conditions")
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 16)
                            .padding(.vertical, 10)
                        }
                        
                        Divider()
                            .padding(.leading, 62)
                            .padding(.trailing, 16)
                        
                        NavigationLink(destination: DocumentsView()) {
                            HStack(spacing: 10) {
                                Image(systemName: "doc.text.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color("NHSRed"))
                                    .clipShape(Circle())
                                
                                Text("Documents")
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 16)
                            .padding(.vertical, 10)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(28)
                    .padding(.horizontal, 16)
                    .padding(.top, 30)
                    
                    
                    
                    
// MARK: - External link rows
                    VStack(alignment: .leading, spacing: 12) {
                        Text("NHS information and support")
                            .font(.headline)
                            .padding(.horizontal, 32)
                            .padding(.top, 32)
                        
                        VStack(spacing: 0) {
                            ExternalLinkRow(title: "Check your symptoms using 111 online",
                                            url: URL(string: "https://111.nhs.uk/")!) { url in
                                selectedLink = LinkItem(title: "Check your symptoms using 111 online", url: url)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            
                            Divider().padding(.horizontal, 16)
                            
                            ExternalLinkRow(title: "Health A to Z",
                                            url: URL(string: "https://www.nhs.uk")!) { url in
                                selectedLink = LinkItem(title: "Health A to Z", url: url)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            
                            Divider().padding(.horizontal, 16)
                            
                            
                            ExternalLinkRow(title: "Find services near you",
                                            url: URL(string: "https://www.nhs.uk")!) { url in
                                selectedLink = LinkItem(title: "Find services near you", url: url)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                        }
                        .background(.clear)
                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.nhsGrey3, lineWidth: 1))
                        .cornerRadius(28)
                        .padding(.horizontal, 16)
                    }
                    
                    
                    
// MARK: - Campaign card
                    VStack(spacing: 0) {
                        CampaignCard(
                            imageName: "campaign_img",
                            title: "Organ donors save lives",
                            subtitle: "Take two minutes to confirm your organ donation decision",
                            backgroundColor: Color("NHSAppDarkBlue"),
                            chevronColor: Color("NHSAppPaleBlue")
                        ) {
                            DetailView(index: 0)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
            }
            .ignoresSafeArea(edges: .top)
            .background(Color(.systemGroupedBackground))
        }
        .fullScreenCover(item: $selectedLink) { link in
            SafariView(url: link.url)
                .ignoresSafeArea()
                .accessibilityFocused($isSafariFocused)
                .onAppear { isSafariFocused = true }
        }
        .sheet(isPresented: $showProfileSheet) {
            ProfileManagementSheet(
                isPresented: $showProfileSheet,
                selectedProfile: $tempSelectedProfile,
                onConfirm: {
                    activeProfile = tempSelectedProfile
                    showProfileSheet = false
                }
            )
        }
    }
}


// MARK: - Profile management sheet

struct ProfileManagementSheet: View {
    @Binding var isPresented: Bool
    @Binding var selectedProfile: HomeView.ProfileOption
    var onConfirm: () -> Void
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                // Main content
                VStack(spacing: 0) {
                    // Title
                    Text("Select profile")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 28)
                        .padding(.bottom, 16)
                    
                    Text("Choose the profile you want to use from this list. If you can't find the item you want, go press a different button.")
                        .font(.body)
                        .padding(.horizontal, 20)

                    
                    // Radio list items
                    List {
                        ForEach(HomeView.ProfileOption.allCases) { option in
                            Button(action: {
                                selectedProfile = option
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(option.name)
                                            .foregroundColor(.primary)
                                            .font(.body)
                                        
                                        Text(option.rawValue)
                                            .foregroundColor(.secondary)
                                            .font(.subheadline)
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedProfile == option {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(Color("NHSGreen"))
                                    }
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .listStyle(.insetGrouped)
                    
                    // Confirm button
                    Button(action: {
                        onConfirm()
                    }) {
                        Text("Confirm your choice")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color("NHSGreen"))
                            .cornerRadius(30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .background(Color(.systemGroupedBackground))

                
                // Close button
                Button(action: {
                    isPresented = false
                }) {
                    ZStack {
                        // Liquid glass effect
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                        
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    
                }
                .padding(.top, 20)
                .padding(.trailing, 20)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(MessageStore())
}
