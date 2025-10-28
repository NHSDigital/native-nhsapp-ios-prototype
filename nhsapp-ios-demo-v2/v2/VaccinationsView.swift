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



// MARK: - Shared flow data
@Observable
class BookingFlowData {
    var answer1: String = ""
    var answer2: String = ""
    var selectedDate: Date?
    // Add any other data you need to share between steps
}



// MARK: - Flow coordinator
struct BookingFlowCoordinator: View {
    @Environment(\.dismiss) private var dismiss
    @State private var navigationPath: [BookingStep] = []
    @State private var flowData = BookingFlowData()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            BookingStep1View(
                flowData: flowData,
                onContinue: {
                    navigationPath.append(.stepTwo(previousAnswer: flowData.answer1))
                },
                onDismiss: {
                    dismiss()
                }
            )
            .navigationDestination(for: BookingStep.self) { step in
                destinationView(for: step)
            }
        }
        .environment(flowData)
    }
    
    @ViewBuilder
    private func destinationView(for step: BookingStep) -> some View {
        switch step {
        case .initial:
            // This won't be used since .initial is the root
            EmptyView()
        case .stepTwo(let previousAnswer):
            BookingStep2View(
                previousAnswer: previousAnswer,
                flowData: flowData,
                onContinue: {
                    navigationPath.append(.stepThree)
                },
                onDismiss: {
                    dismiss()
                }
            )
        case .stepThree:
            BookingStep3View(
                flowData: flowData,
                onComplete: {
                    dismiss()
                },
                onDismiss: {
                    dismiss()
                }
            )
        }
    }
}



// MARK: - Form step enum
enum BookingStep: Hashable {
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
    let flowData: BookingFlowData
    let onContinue: () -> Void
    let onDismiss: () -> Void
    
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
                    // You can update flowData here before continuing
                    flowData.answer1 = "some answer"
                    onContinue()
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    onDismiss()
                }) {
                    Image(systemName: "xmark")
                        .accessibilityLabel("Close this form")
                }
            }
        }
    }
}

struct BookingStep2View: View {
    let previousAnswer: String
    let flowData: BookingFlowData
    let onContinue: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Step 2: Additional Information")
                        .font(.largeTitle)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Previous answer: \(previousAnswer)")
                    
                    // You can also access shared data
                    Text("From shared data: \(flowData.answer1)")
                    
                    // Content here
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 0) {
                Divider()
                Button(action: {
                    // Update shared data before continuing
                    flowData.answer2 = "another answer"
                    onContinue()
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    onDismiss()
                }) {
                    Image(systemName: "xmark")
                        .accessibilityLabel("Close this form")
                }
            }
        }
    }
}

struct BookingStep3View: View {
    let flowData: BookingFlowData
    let onComplete: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Final Step")
                        .font(.largeTitle)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Access all the data collected
                    Text("Answer 1: \(flowData.answer1)")
                    Text("Answer 2: \(flowData.answer2)")
                    
                    // Content here
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 0) {
                Divider()
                Button(action: {
                    // Complete the flow
                    onComplete()
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    onDismiss()
                }) {
                    Image(systemName: "xmark")
                        .accessibilityLabel("Close this form")
                }
            }
        }
    }
}



// MARK: - Preview
#Preview() {
    AppFlowPreview()
}
