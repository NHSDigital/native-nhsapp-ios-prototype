import SwiftUI

struct VaccinationsView: View {
    @State private var showBookingFlow = false
    
    var body: some View {
        List {
            Section {
                // Custom row that looks like RowLink but opens a sheet
                HStack {
                    Text("Book or read about vaccinations")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.accentColor.opacity(0.7))
                        .accessibilityHidden(true)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    showBookingFlow = true
                }
                
                RowLink(title: "Your vaccinations") { DetailView(index: 0) }
                RowLink(title: "COVID-19 vaccinations") { DetailView(index: 0) }
            }
            .rowStyle(.white)
        }
        .navigationTitle("Vaccinations")
        .navigationBarTitleDisplayMode(.large)
        .nhsListStyle()
        .sheet(isPresented: $showBookingFlow) {
            BookingFlowCoordinator()
        }
    }
}



// MARK: - Flow Coordinator
struct BookingFlowCoordinator: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: BookingStep = .initial
    @State private var navigationPath: [BookingStep] = []
    @State private var isNavigatingForward = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Use the step's ID to give SwiftUI a stable identity for transitions
                stepView(for: currentStep)
                    .id(currentStep.id)
                    .transition(.asymmetric(
                        insertion: .move(edge: isNavigatingForward ? .trailing : .leading),
                        removal: .move(edge: isNavigatingForward ? .leading : .trailing)
                    ))
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !navigationPath.isEmpty {
                        Button(action: {
                            if let previousStep = navigationPath.popLast() {
                                isNavigatingForward = false
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentStep = previousStep
                                }
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .accessibilityLabel("Back")
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .accessibilityLabel("Close this form")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func stepView(for step: BookingStep) -> some View {
        switch step {
        case .initial:
            BookingStep1View(navigateToNext: { nextStep in
                navigationPath.append(currentStep)
                isNavigatingForward = true
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentStep = nextStep
                }
            })
        case .stepTwo(let previousAnswer):
            BookingStep2View(
                previousAnswer: previousAnswer,
                navigateToNext: { nextStep in
                    navigationPath.append(currentStep)
                    isNavigatingForward = true
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep = nextStep
                    }
                }
            )
        case .stepThree:
            BookingStep3View(navigateToNext: { _ in
                // Final step
            })
        }
    }
}



// MARK: - Form step enum
enum BookingStep {
    case initial
    case stepTwo(previousAnswer: String)
    case stepThree
    
    // Add a computed property for unique identification
    var id: String {
        switch self {
        case .initial:
            return "initial"
        case .stepTwo:
            return "stepTwo"
        case .stepThree:
            return "stepThree"
        }
    }
}



// MARK: - Form steps
struct BookingStep1View: View {
    let navigateToNext: (BookingStep) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Book or read about vaccinations")
                        .font(.largeTitle)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                
                    Text("Use this service to book available appointments at your GP surgery.")
                        .font(.body)
                        
                    // Inset text component
                    HStack(spacing: 0) {
                        
                        // Draw the line on the left
                        Rectangle()
                            .fill(Color.nhsBlue)
                            .frame(width: 8)
                        
                        // The text area
                        VStack(alignment: .leading, spacing: 16) {
                            
                            Text("A message from your GP surgery")
                                .font(.headline)
                            
                            Text("Blood tests are INVITE ONLY and should be booked with Nurse Donna at the Southbank Practice. Also book with Donna for warfarin clinic and b12 injections. Please remember to cancel your appointment if it is no longer needed. Thanks")
                                .font(.body)
                        }
                        .padding(.leading, 16)
                        
                    } // end of the inset text component
                    
                    Divider()

                    Text("For urgent medical advice, call 111 or visit 111.nhs.uk")
                        .font(.body)
                    
                    // Ghost button for 111 Online
                    RowLink {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("111 Online")
                                .padding(.bottom, 4)
                        }
                        .padding(.vertical, 16)
                    } destination: { DetailView(index: 0) }
                    .padding(.horizontal, 20)
                    .background(Color.clear)
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.nhsGrey4, lineWidth: 1)) 
                    
                    
                } // End of the content area
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Bottom button
            VStack(spacing: 0) {
                Divider()
                Button(action: {
                    navigateToNext(.stepTwo(previousAnswer: "some answer"))
                }) {
                    Text("Start now")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.nhsGreen)
                        .cornerRadius(30)
                }
                .padding()
            }
            .background(Color("NHSGrey5"))
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
    }
}

struct BookingStep2View: View {
    let previousAnswer: String
    let navigateToNext: (BookingStep) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Step 2: Additional Information")
                        .font(.largeTitle)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Previous answer: \(previousAnswer)")
                    
                    // Content here
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 0) {
                Divider()
                Button(action: {
                    navigateToNext(.stepThree)
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.nhsGreen)
                        .cornerRadius(30)
                }
                .padding()
            }
            .background(Color("NHSGrey5"))
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
    }
}

struct BookingStep3View: View {
    let navigateToNext: (BookingStep) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Final Step")
                        .font(.largeTitle)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Content here
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 0) {
                Divider()
                Button(action: {
                    // Complete the flow
                    dismiss()
                }) {
                    Text("Complete")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.nhsGreen)
                        .cornerRadius(30)
                }
                .padding()
            }
            .background(Color("NHSGrey5"))
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
    }
}



// MARK: - Preview
#Preview {
    VaccinationsView()
}
