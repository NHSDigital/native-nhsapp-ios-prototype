import SwiftUI

struct AppointmentTypeSelectionView: View {
    @State private var selectedType: String? = nil
    @State private var scrollOffset: CGFloat = 0
    @Environment(\.dismiss) private var dismiss   // <— get the dismiss action
    
    let appointmentTypes = [
        "GP appointment",
        "Nurse appointment",
        "Telephone consultation",
        "Video consultation"
    ]
    
    var body: some View {
        ZStack {
            Color.pageBackground.ignoresSafeArea()
            
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Custom header that wraps
                        Text("Select a type of appointment")
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            .padding(.bottom, 32)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(key: ScrollOffsetPreferenceKey.self,
                                                    value: geo.frame(in: .named("scroll")).minY)
                                }
                            )
                        
                        // List items as separate buttons
                        VStack(spacing: 12) {
                            ForEach(appointmentTypes, id: \.self) { type in
                                Button(action: { selectedType = type }) {
                                    HStack {
                                        Image(systemName: selectedType == type ? "circle.fill" : "circle")
                                            .foregroundColor(selectedType == type ? Color(red: 2/255, green: 127/255, blue: 58/255) : .gray)
                                            .font(.system(size: 20))
                                        
                                        Text(type)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(30)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100) // Space for the button
                    }
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                }
                
                // Continue button (fixed at bottom)
                VStack {
                    Spacer()
                    Button(action: {
                        // Add action to continue
                    }) {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .bold()
                            .background(selectedType != nil ? Color(red: 2/255, green: 127/255, blue: 58/255) : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .disabled(selectedType == nil)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.pageBackground.opacity(0), Color.pageBackground]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 120)
                    .offset(y: geometry.size.height - 120)
                )
            }
            .toolbar {
                // Dynamic inline title when scrolled
                ToolbarItem(placement: .principal) {
                    Text(scrollOffset < -50 ? "Select an appointment type" : "")
                        .font(.headline)
                }
                
                // Top-right "Close" button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.weight(.regular))
                    }
                    .accessibilityLabel("Close")
                }
            }
            .toolbarTitleDisplayMode(.inline) // keeps the top bar compact in a sheet
        }
    }
}


#Preview {
    NavigationView {
        AppointmentsView(activeProfile: .self_)
    }
}
