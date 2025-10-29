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
    var selectedAppointmentType: String = ""
    var selectedDateTime: Date?
    var appointmentReason: String = ""
    var selectedPhoneNumber: String = ""
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
                    navigationPath.append(.selectAppointmentType)
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
            EmptyView()
        case .selectAppointmentType:
            BookingStep2View(
                flowData: flowData,
                onContinue: {
                    // Check if we're editing from confirmation screen
                    if navigationPath.contains(.confirmationStep) {
                        // Pop back to confirmation
                        navigationPath.removeLast()
                    } else {
                        // Normal flow - continue to next step
                        navigationPath.append(.selectDateTime)
                    }
                },
                onDismiss: {
                    dismiss()
                }
            )
        case .selectDateTime:
            BookingStep3View(
                flowData: flowData,
                onContinue: {
                    if navigationPath.contains(.confirmationStep) {
                        navigationPath.removeLast()
                    } else {
                        navigationPath.append(.appointmentReason)
                    }
                },
                onDismiss: {
                    dismiss()
                }
            )
        case .appointmentReason:
            BookingStep4View(
                flowData: flowData,
                onContinue: {
                    if navigationPath.contains(.confirmationStep) {
                        navigationPath.removeLast()
                    } else {
                        navigationPath.append(.selectPhoneNumber)
                    }
                },
                onDismiss: {
                    dismiss()
                }
            )
        case .selectPhoneNumber:
            BookingStep5View(
                flowData: flowData,
                onContinue: {
                    if navigationPath.contains(.confirmationStep) {
                        navigationPath.removeLast()
                    } else {
                        navigationPath.append(.confirmationStep)
                    }
                },
                onDismiss: {
                    dismiss()
                }
            )
        case .confirmationStep:
            BookingStep6View(
                flowData: flowData,
                onComplete: {
                    navigationPath.append(.finalConfirmation)
                },
                onDismiss: {
                    dismiss()
                }
            )
        case .finalConfirmation:
            BookingStep7View(
                flowData: flowData,
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
    case selectAppointmentType
    case selectDateTime
    case appointmentReason
    case selectPhoneNumber
    case confirmationStep
    case finalConfirmation
    
    var id: String {
        switch self {
        case .initial:
            return "initial"
        case .selectAppointmentType:
            return "selectAppointmentType"
        case .selectDateTime:
            return "selectDateTime"
        case .appointmentReason:
            return "appointmentReason"
        case .selectPhoneNumber:
            return "selectPhoneNumber"
        case .confirmationStep:
            return "confirmationStep"
        case .finalConfirmation:
            return "finalConfirmation"
        }
    }
}



// MARK: - Form step 1
struct BookingStep1View: View {
    let flowData: BookingFlowData
    let onContinue: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Book an available GP appointment")
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
//                Divider()
                Button(action: {
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
//            .background(Color("NHSGrey5"))
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

// MARK: - Form step 2 - Select appointment type
struct BookingStep2View: View {
    let flowData: BookingFlowData
    let onContinue: () -> Void
    let onDismiss: () -> Void
    
    @State private var selectedAppointmentType: AppointmentType?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Select an appointment type")
                        .font(.title)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Radio list items
                    List {
                        ForEach(AppointmentType.allCases) { option in
                            Button(action: {
                                selectedAppointmentType = option
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(option.title)
                                            .foregroundColor(.black)
                                            .font(.body)
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedAppointmentType == option {
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
                    .frame(height: CGFloat(AppointmentType.allCases.count) * 60)
                    .scrollDisabled(true)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 0) {
//                Divider()
                Button(action: {
                    if let selectedType = selectedAppointmentType {
                        flowData.selectedAppointmentType = selectedType.title
                        onContinue()
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedAppointmentType != nil ? Color.nhsGreen : Color.nhsGreen)
                        .cornerRadius(30)
                }
                .disabled(selectedAppointmentType == nil)
                .padding()
            }
//            .background(Color("NHSGrey5"))
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

enum AppointmentType: String, CaseIterable, Identifiable {
    case asthma = "asthma"
    case bloodTest = "bloodTest"
    case generalGP = "generalGP"
    case contraception = "contraception"
    case onlineForm = "onlineForm"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .asthma:
            return "Asthma clinic"
        case .bloodTest:
            return "Blood test"
        case .generalGP:
            return "General GP appointment"
        case .contraception:
            return "Contraception appointment"
        case .onlineForm:
            return "Contact your GP using an online form"
        }
    }
}

// MARK: - Form step 3 - Select date and time
struct BookingStep3View: View {
    let flowData: BookingFlowData
    let onContinue: () -> Void
    let onDismiss: () -> Void
    
    @State private var selectedDateTime: Date = Date()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Select an appointment date and time")
                        .font(.title)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Date picker
                    DatePicker("Select date and time", selection: $selectedDateTime, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.graphical)
                    
                    // You can add more UI elements here like available time slots
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 0) {
//                Divider()
                Button(action: {
                    flowData.selectedDateTime = selectedDateTime
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
//            .background(Color("NHSGrey5"))
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

// MARK: - Form step 4 - Appointment reason
struct BookingStep4View: View {
    let flowData: BookingFlowData
    let onContinue: () -> Void
    let onDismiss: () -> Void
    
    @State private var appointmentReason: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("What is the reason for your appointment?")
                        .font(.title)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Please provide a brief description of why you need this appointment.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    // Text editor for reason
                    TextEditor(text: $appointmentReason)
                        .frame(minHeight: 150)
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.nhsGrey4, lineWidth: 1)
                        )
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 0) {
//                Divider()
                Button(action: {
                    flowData.appointmentReason = appointmentReason
                    onContinue()
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(!appointmentReason.isEmpty ? Color.nhsGreen : Color.nhsGreen)
                        .cornerRadius(30)
                }
                .disabled(appointmentReason.isEmpty)
                .padding()
            }
//            .background(Color("NHSGrey5"))
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

// MARK: - Form step 5 - Select phone number
struct BookingStep5View: View {
    let flowData: BookingFlowData
    let onContinue: () -> Void
    let onDismiss: () -> Void
    
    @State private var selectedPhoneNumber: PhoneNumberOption?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Select a phone number for this appointment")
                        .font(.title)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    Text("We'll call you on this number if we need to contact you about your appointment.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    // Phone number options
                    VStack(spacing: 0) {
                        ForEach(PhoneNumberOption.allCases) { option in
                            Button(action: {
                                selectedPhoneNumber = option
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(option.label)
                                            .foregroundColor(.black)
                                            .font(.body)
                                        Text(option.number)
                                            .foregroundColor(.secondary)
                                            .font(.subheadline)
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedPhoneNumber == option {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(Color("NHSGreen"))
                                    }
                                }
                                .contentShape(Rectangle())
                                .padding()
                            }
                            .buttonStyle(.plain)
                            .background(Color.white)
                            
                            if option != PhoneNumberOption.allCases.last {
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(30)
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 0) {
//                Divider()
                Button(action: {
                    if let phone = selectedPhoneNumber {
                        flowData.selectedPhoneNumber = phone.number
                        onContinue()
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedPhoneNumber != nil ? Color.nhsGreen : Color.nhsGreen)
                        .cornerRadius(30)
                }
                .disabled(selectedPhoneNumber == nil)
                .padding()
            }
//            .background(Color("NHSGrey5"))
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

enum PhoneNumberOption: String, CaseIterable, Identifiable {
    case mobile = "mobile"
    case home = "home"
    case work = "work"
    
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .mobile:
            return "Mobile"
        case .home:
            return "Home"
        case .work:
            return "Work"
        }
    }
    
    var number: String {
        switch self {
        case .mobile:
            return "07123 456789"
        case .home:
            return "020 1234 5678"
        case .work:
            return "020 9876 5432"
        }
    }
}

// MARK: - Form step 6 - Final confirmation
struct BookingStep6View: View {
    let flowData: BookingFlowData
    let onComplete: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Confirm your appointment details")
                        .font(.title)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Summary of all collected data with edit links
                    VStack(alignment: .leading, spacing: 0) {
                        NavigationLink(value: BookingStep.selectAppointmentType) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Appointment type")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.gray)
                                    Text(flowData.selectedAppointmentType)
                                        .font(.body)
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary.opacity(0.7))
                            }
                            .contentShape(Rectangle())
                            .padding(.vertical, 12)
                        }
                        
                        Divider()
                        
                        NavigationLink(value: BookingStep.selectDateTime) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Date and time")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.gray)
                                    if let dateTime = flowData.selectedDateTime {
                                        Text(dateTime.formatted(date: .long, time: .shortened))
                                            .font(.body)
                                            .foregroundColor(.black)
                                    }
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary.opacity(0.7))
                            }
                            .contentShape(Rectangle())
                            .padding(.vertical, 12)
                        }
                        
                        Divider()
                        
                        NavigationLink(value: BookingStep.appointmentReason) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Reason")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.gray)
                                    Text(flowData.appointmentReason)
                                        .font(.body)
                                        .foregroundColor(.black)
                                        .lineLimit(2)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary.opacity(0.7))
                            }
                            .contentShape(Rectangle())
                            .padding(.vertical, 12)
                        }
                        
                        Divider()
                        
                        NavigationLink(value: BookingStep.selectPhoneNumber) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Contact number")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.gray)
                                    Text(flowData.selectedPhoneNumber)
                                        .font(.body)
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary.opacity(0.7))
                            }
                            .contentShape(Rectangle())
                            .padding(.vertical, 12)
                        }
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(30)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 0) {
                Button(action: {
                    onComplete()
                }) {
                    Text("Confirm booking")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.nhsGreen)
                        .cornerRadius(30)
                }
                .padding()
            }
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



// MARK: - Form step 7 - Final confirmation screen
struct BookingStep7View: View {
    let flowData: BookingFlowData
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // Green title box
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Appointment confirmed")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                        .background(Color.nhsGreen)
                        .cornerRadius(30)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)

                    
                    // Main content area
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // What happens next section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("What happens next")
                                .font(.title3)
                                .bold()
                            
                            Text("You will be called by your GP surgery at 8:15 on Wednesday, 24 July 2025. Keep your phone with you at all times, and be aware the GP number may be withheld.")
                                .font(.body)

                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)
                                                
                        // Appointment details card
                        VStack(alignment: .leading, spacing: 12) {
                            
                            // Appointment details text
                            VStack(alignment: .leading, spacing: 12) {
                                
                                Text("Your appointment details")
                                    .font(.body)
                                    .foregroundColor(Color.nhsGrey1)
                                
                                Text(flowData.selectedAppointmentType)
                                    .font(.body)
                                    .bold()
                                
                                if let dateTime = flowData.selectedDateTime {
                                    Text(dateTime.formatted(date: .long, time: .shortened))
                                        .font(.body)
                                        .bold()
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Southbank Practice")
                                        .font(.body)
                                    Text("12345 Bottom Boulevard")
                                        .font(.body)
                                    Text("London, SE1 6AB")
                                        .font(.body)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                            .padding(.bottom, 4)
                            
                            Button(action: {
                                // Add to calendar action
                            }) {
                                Text("Add to your calendar")
                                    .font(.headline)
                                    .foregroundColor(Color.nhsBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.clear)
                                    .cornerRadius(30)
                                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.nhsBlue, lineWidth: 1))

                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                            .padding(.bottom, 16)
                        }
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(30)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Bottom button
            VStack(spacing: 0) {
//                Divider()
                NavigationLink(destination: AppointmentsView()) {
                    Text("Exit this service")
                        .font(.body)
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity)
                        .padding()
//                        .background(Color.white)
                        .cornerRadius(30)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    onDismiss()
                })
                .padding()
            }
//            .background(Color("NHSGrey5"))
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // Hide back button on confirmation screen
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
    VaccinationsView()
}
