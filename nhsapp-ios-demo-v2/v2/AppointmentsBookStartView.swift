import SwiftUI

struct AppointmentsBookStartView: View {
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.pageBackground.ignoresSafeArea()
            
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        
                        // Custom header that wraps
                        Text("Check for available appointments")
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            .padding(.bottom, 16)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(key: ScrollOffsetPreferenceKey.self,
                                                  value: geo.frame(in: .named("scroll")).minY)
                                }
                            )
                        
                        // Top section with white/page background
                        VStack(alignment: .leading, spacing: 24) {
                            
                            Text("Use this service to book available appointments at your GP surgery.")
                                .font(.body)
                            
                            
                            // Inset text component
                            HStack(spacing: 0) {
                                
                                // Draw the line on the left
                                Rectangle()
                                    .fill(Color.nhsBlue)
                                    .frame(width: 4)
                                
                                // The text area
                                VStack(alignment: .leading, spacing: 16) {
                                    
                                    Text("A message from your GP surgery")
                                        .fontWeight(.bold)
                                    
                                    Text("Blood tests are INVITE ONLY and should be booked with Nurse Donna at the Southbank Practice. Also book with Donna for warfarin clinic and b12 injections. Please remember to cancel your appointment if it is no longer needed. Thanks")
                                        .font(.body)
                                }
                                .foregroundColor(Color("NHSGrey1"))
                                .padding(.leading, 16)
                                
                            } // end of the inset text component
                            

                            
                            Button(action: {
                                // Add action to request prescription here
                            }) {
                                NavigationLink(destination: AppointmentTypeSelectionView()) {
                                    Text("Start now")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .bold()
                                        .background(Color(red: 2/255, green: 127/255, blue: 58/255)) // #027F3A
                                        .foregroundColor(.white)
                                        .cornerRadius(30)
                                }
                                .buttonStyle(.plain)
                            }
                            
                        } // end top VStack
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.vertical)
                        .padding(.bottom, 32)
                        
                        // Bottom section with different background
                        VStack(alignment: .leading, spacing: 24) {
                            
                            Text("For urgent medical advice, call 111 or visit 111 online by clicking the button below.")
                            
                            Button(action: {
                                // Add action to request prescription here
                            }) {
                                Text("Visit 111 online")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.5))
                                    .foregroundColor(.black)
                                    .cornerRadius(30)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.vertical)
                        .padding(.top, 32)
                        .background(Color.gray.opacity(0.1))
                        
                        // Extension to fill remaining space
                        Color.gray.opacity(0.1)
                            .frame(height: max(0, geometry.size.height - 300))
                        
                    } // end main VStack
                } // end ScrollView
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                }
                .navigationTitle(scrollOffset < -50 ? "Check for available appointments" : "")
                .navigationBarTitleDisplayMode(.inline)
            }
            
        } // end Zstack
    } // end body

}

#Preview {
    AppointmentsBookStartView()
}


