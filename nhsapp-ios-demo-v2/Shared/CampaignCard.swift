import SwiftUI

// MARK: - Reusable CampaignCard
struct CampaignCard<Destination: View>: View {
    let imageName: String
    let title: String
    let subtitle: String
    let backgroundColor: Color
    let chevronColor: Color
    @ViewBuilder var destination: Destination

    init(
        imageName: String,
        title: String,
        subtitle: String,
        backgroundColor: Color = Color("NHSAppDarkBlue"),
        chevronColor: Color = Color("NHSAppPaleBlue"),
        @ViewBuilder destination: () -> Destination
    ) {
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
        self.backgroundColor = backgroundColor
        self.chevronColor = chevronColor
        self.destination = destination()
    }

    var body: some View {
        VStack(spacing: 0) {
            // --- Image ---
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipped()

            // --- Content (tap to navigate) ---
            NavigationLink {
                destination
            } label: {
                HStack(alignment: .center, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(title)
                            .font(.title2)
                            .foregroundColor(Color("NHSWhite"))
                            .bold()

                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(Color("NHSWhite"))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(chevronColor)
                        .font(.headline)
                        .imageScale(.medium)
                        .padding(.trailing, -4) // 👈 precise right spacing
                }
                .padding(.leading, 16)  // left side only
                .padding(.vertical, 16)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .background(backgroundColor)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(radius: 2)
    }
}

// MARK: - Convenience list row modifier (optional)
extension View {
    /// Removes default list padding + bg so the card edge-to-edge looks clean in a List.
    func campaignCardRowStyle() -> some View {
        self
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
    }
}

#Preview("CampaignCard") {
    NavigationStack {
        List {
            Section {
                CampaignCard(
                    imageName: "campaign_img",
                    title: "Organ donors save lives",
                    subtitle: "Take two minutes to confirm your organ donation decision",
                    backgroundColor: Color("NHSAppDarkBlue"),
                    chevronColor: Color("NHSAppPaleBlue")
                ) {
                    // Example destination
                    Text("Organ Donation Details")
                        .navigationTitle("Organ Donation")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .campaignCardRowStyle()
        }
    }
}
