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
            VStack(spacing: 0) {
                // Content area with transitions
                ZStack {
                    stepView(for: currentStep)
                        .id(currentStep.id)
                        .transition(.asymmetric(
                            insertion: .move(edge: isNavigatingForward ? .trailing : .leading),
                            removal: .move(edge: isNavigatingForward ? .leading : .trailing)
                        ))
                }
                
                // Fixed bottom button (outside the transition)
                VStack(spacing: 0) {
                    Divider()
                    Button(action: {
                        handleButtonTap()
                    }) {
                        Text(buttonText)
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
    
    // Computed property for button text
    private var buttonText: String {
        switch currentStep {
        case .initial:
            return "Start now"
        case .stepTwo:
            return "Continue"
        case .stepThree:
            return "Complete"
        }
    }
    
    // Handle button action based on current step
    private func handleButtonTap() {
        switch currentStep {
        case .initial:
            navigationPath.append(currentStep)
            isNavigatingForward = true
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep = .stepTwo(previousAnswer: "some answer")
            }
        case .stepTwo:
            navigationPath.append(currentStep)
            isNavigatingForward = true
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep = .stepThree
            }
        case .stepThree:
            dismiss()
        }
    }
    
    @ViewBuilder
    private func stepView(for step: BookingStep) -> some View {
        switch step {
        case .initial:
            BookingStep1Content()
        case .stepTwo(let previousAnswer):
            BookingStep2Content(previousAnswer: previousAnswer)
        case .stepThree:
            BookingStep3Content()
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



// MARK: - Form step content views (without buttons)
struct BookingStep1Content: View {
    var body: some View {
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
                    Rectangle()
                        .fill(Color.nhsBlue)
                        .frame(width: 8)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("A message from your GP surgery")
                            .font(.headline)
                        
                        Text("Blood tests are INVITE ONLY and should be booked with Nurse Donna at the Southbank Practice. Also book with Donna for warfarin clinic and b12 injections. Please remember to cancel your appointment if it is no longer needed. Thanks")
                            .font(.body)
                    }
                    .padding(.leading, 16)
                }
                
                Divider()

                Text("For urgent medical advice, call 111 or visit 111.nhs.uk")
                    .font(.body)
                
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
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
    }
}

struct BookingStep2Content: View {
    let previousAnswer: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Step 2: Additional Information")
                    .font(.largeTitle)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Previous answer: \(previousAnswer)")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
    }
}

struct BookingStep3Content: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Final Step")
                    .font(.largeTitle)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
    }
}


// MARK: - Preview
#Preview() {
    AppFlowPreview()
}
