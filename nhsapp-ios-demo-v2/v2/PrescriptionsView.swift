import SwiftUI

struct PrescriptionsView: View {
    
    @State private var showPrescriptionCard = true

    var body: some View {
        List {
            
            // Prescription card - dismissable
            if showPrescriptionCard {
                Section {
                    ZStack(alignment: .topTrailing) {
                            
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Ready to collect")
                                    .font(.body)
                                    .bold()
                                Text("Ramipril 50mg | Order 557579689")
                            }
                            Spacer(minLength: 40)
                        }

                        Button {
                            withAnimation(.easeInOut) {
                                showPrescriptionCard = false
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color("NHSAppDarkPurple"))
                                .accessibilityLabel("Dismiss prescription card")
                        }
                        .accessibilityLabel("Dismiss prescription card")
                        .accessibilityHint("Hides the ‘Ready to collect’ message.")
                        
                    }
                    RowLink(title: "View prescription", chevronColor: Color("NHSAppDarkPurple").opacity(0.7)) { DetailView(index: 0) }
                }
                .rowStyle(.palePurple)
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            Section {

                RowLink(title: "Request a repeat prescription") {
                    PrescriptionsRequestView()
                }
                
                RowLink(title: "Check the progress of prescriptions") { DetailView(index: 0) }
                RowLink(title: "Medicines record") { DetailView(index: 0) }
                RowLink(title: "Request an emergency prescription") { DetailView(index: 0) }
                RowLink {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your chosen pharmacy")
                        Text("Wellcare Pharmacy")
                            .font(.subheadline)
                            .foregroundStyle(.textSecondary)
                    }
                    .padding(.vertical, 4)
                } destination: {
                    DetailView(index: 0)
                }
            } header: {
                Text("GP surgery")
            }
            .rowStyle(.white)
            
            Section {
                RowLink(title: "Hospital and other medicines") { DetailView(index: 0) }
            } header: {
                Text("Hospital")
            }
            .rowStyle(.white)

        }
        .navigationTitle("Prescriptions")
        .navigationBarTitleDisplayMode(.large)
        .nhsListStyle()
    }
}

#Preview {
    PrescriptionsView()
}
