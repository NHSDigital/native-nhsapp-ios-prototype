import SwiftUI

// MARK: - Flow step 1: start screen
struct BookingEmbeddedStep1View: View {
    @State private var flowData = BookingFlowData()
    @Environment(\.dismissToRoot) private var dismissToRoot
    
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
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 0) {
                NavigationLink(destination: BookingEmbeddedStep2View(flowData: flowData)
                    .environment(\.dismissToRoot, dismissToRoot)) {
                    Text("Start now")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.nhsGreen)
                        .cornerRadius(30)
                }
                .buttonStyle(.plain)
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
        .environment(flowData)
    }
}

// MARK: - Flow step 2: select appointment type
struct BookingEmbeddedStep2View: View {
    @State var flowData: BookingFlowData
    @State private var selectedAppointmentType: AppointmentType?
    @Environment(\.dismissToRoot) private var dismissToRoot
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Select an appointment type")
                    .font(.title)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                    .padding(.top)
                
                List {
                    ForEach(AppointmentType.allCases) { option in
                        Button(action: {
                            selectedAppointmentType = option
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(option.title)
                                        .foregroundColor(.nhsBlack)
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
                .scrollContentBackground(.hidden)
            }
            
            VStack(spacing: 0) {
                NavigationLink(destination: BookingEmbeddedStep3View(flowData: flowData)
                    .environment(\.dismissToRoot, dismissToRoot)) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedAppointmentType != nil ? Color.nhsGreen : Color.nhsGreen)
                        .cornerRadius(30)
                }
                .buttonStyle(.plain)
                .disabled(selectedAppointmentType == nil)
                .simultaneousGesture(TapGesture().onEnded {
                    if let selectedType = selectedAppointmentType {
                        flowData.selectedAppointmentType = selectedType.title
                    }
                })
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
        .environment(flowData)
    }
}

// MARK: - Flow step 3: select date and time
struct BookingEmbeddedStep3View: View {
    @Environment(\.dismissToRoot) private var dismissToRoot
    @State var flowData: BookingFlowData
    @State private var selectedDateTime: Date = Date()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Select an appointment date and time")
                        .font(.title)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    DatePicker("Select date and time", selection: $selectedDateTime, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.graphical)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 0) {
                NavigationLink(destination: BookingEmbeddedStep4View(flowData: flowData)
                    .environment(\.dismissToRoot, dismissToRoot)) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.nhsGreen)
                        .cornerRadius(30)
                }
                .buttonStyle(.plain)
                .simultaneousGesture(TapGesture().onEnded {
                    flowData.selectedDateTime = selectedDateTime
                })
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
        .environment(flowData)
    }
}

// MARK: - Flow step 4: appointment reason
struct BookingEmbeddedStep4View: View {
    @Environment(\.dismissToRoot) private var dismissToRoot
    @State var flowData: BookingFlowData
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
                NavigationLink(destination: BookingEmbeddedStep5View(flowData: flowData)
                    .environment(\.dismissToRoot, dismissToRoot)) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(!appointmentReason.isEmpty ? Color.nhsGreen : Color.nhsGreen)
                        .cornerRadius(30)
                }
                .buttonStyle(.plain)
                .disabled(appointmentReason.isEmpty)
                .simultaneousGesture(TapGesture().onEnded {
                    flowData.appointmentReason = appointmentReason
                })
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
        .environment(flowData)
    }
}

// MARK: - Flow step 5: select phone number
struct BookingEmbeddedStep5View: View {
    @Environment(\.dismissToRoot) private var dismissToRoot
    @State var flowData: BookingFlowData
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
                    
                    VStack(spacing: 0) {
                        ForEach(PhoneNumberOption.allCases) { option in
                            Button(action: {
                                selectedPhoneNumber = option
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(option.label)
                                            .foregroundColor(.nhsBlack)
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
                NavigationLink(destination: BookingEmbeddedStep6View(flowData: flowData)
                    .environment(\.dismissToRoot, dismissToRoot)) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedPhoneNumber != nil ? Color.nhsGreen : Color.nhsGreen)
                        .cornerRadius(30)
                }
                .buttonStyle(.plain)
                .disabled(selectedPhoneNumber == nil)
                .simultaneousGesture(TapGesture().onEnded {
                    if let phone = selectedPhoneNumber {
                        flowData.selectedPhoneNumber = phone.number
                    }
                })
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
        .environment(flowData)
    }
}

// MARK: - Flow step 6: confirm details
struct BookingEmbeddedStep6View: View {
    @Environment(\.dismissToRoot) private var dismissToRoot
    @State var flowData: BookingFlowData
    @State private var showEditAppointmentType = false
    @State private var showEditDateTime = false
    @State private var showEditReason = false
    @State private var showEditPhoneNumber = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Confirm your appointment details")
                        .font(.title)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Button(action: {
                            showEditAppointmentType = true
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Appointment type")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.gray)
                                    Text(flowData.selectedAppointmentType)
                                        .font(.body)
                                        .foregroundColor(.nhsBlack)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary.opacity(0.7))
                            }
                            .contentShape(Rectangle())
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.plain)
                        
                        Divider()
                        
                        Button(action: {
                            showEditDateTime = true
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Date and time")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.gray)
                                    if let dateTime = flowData.selectedDateTime {
                                        Text(dateTime.formatted(date: .long, time: .shortened))
                                            .font(.body)
                                            .foregroundColor(.nhsBlack)
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
                        .buttonStyle(.plain)
                        
                        Divider()
                        
                        Button(action: {
                            showEditReason = true
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Reason")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.gray)
                                    Text(flowData.appointmentReason)
                                        .font(.body)
                                        .foregroundColor(.nhsBlack)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary.opacity(0.7))
                            }
                            .contentShape(Rectangle())
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.plain)
                        
                        Divider()
                        
                        Button(action: {
                            showEditPhoneNumber = true
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Contact number")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.gray)
                                    Text(flowData.selectedPhoneNumber)
                                        .font(.body)
                                        .foregroundColor(.nhsBlack)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary.opacity(0.7))
                            }
                            .contentShape(Rectangle())
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(30)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 0) {
                NavigationLink(destination: BookingEmbeddedStep7View(flowData: flowData)
                    .environment(\.dismissToRoot, dismissToRoot)) {
                    Text("Confirm booking")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.nhsGreen)
                        .cornerRadius(30)
                }
                .buttonStyle(.plain)
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
        .environment(flowData)
        .sheet(isPresented: $showEditAppointmentType) {
            EditAppointmentTypeSheet(flowData: flowData, isPresented: $showEditAppointmentType)
        }
        .sheet(isPresented: $showEditDateTime) {
            EditDateTimeSheet(flowData: flowData, isPresented: $showEditDateTime)
        }
        .sheet(isPresented: $showEditReason) {
            EditReasonSheet(flowData: flowData, isPresented: $showEditReason)
        }
        .sheet(isPresented: $showEditPhoneNumber) {
            EditPhoneNumberSheet(flowData: flowData, isPresented: $showEditPhoneNumber)
        }
    }
}

// MARK: - Edit sheets for checking answers

struct EditAppointmentTypeSheet: View {
    @State var flowData: BookingFlowData
    @Binding var isPresented: Bool
    @State private var selectedAppointmentType: AppointmentType?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Select an appointment type")
                        .font(.title)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    List {
                        ForEach(AppointmentType.allCases) { option in
                            Button(action: {
                                selectedAppointmentType = option
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(option.title)
                                            .foregroundColor(.nhsBlack)
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
                    .scrollContentBackground(.hidden)
                }
                
                VStack(spacing: 0) {
                    Button(action: {
                        if let selectedType = selectedAppointmentType {
                            flowData.selectedAppointmentType = selectedType.title
                            isPresented = false
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
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("NHSGrey5"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .accessibilityLabel("Close")
                    }
                }
            }
        }
        .onAppear {
            // Pre-select the current value
            selectedAppointmentType = AppointmentType.allCases.first { $0.title == flowData.selectedAppointmentType }
        }
    }
}

struct EditDateTimeSheet: View {
    @State var flowData: BookingFlowData
    @Binding var isPresented: Bool
    @State private var selectedDateTime: Date = Date()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Select an appointment date and time")
                            .font(.title)
                            .bold()
                            .fixedSize(horizontal: false, vertical: true)
                        
                        DatePicker("Select date and time", selection: $selectedDateTime, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.graphical)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(spacing: 0) {
                    Button(action: {
                        flowData.selectedDateTime = selectedDateTime
                        isPresented = false
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
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("NHSGrey5"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .accessibilityLabel("Close")
                    }
                }
            }
        }
        .onAppear {
            // Pre-fill with current value
            if let currentDateTime = flowData.selectedDateTime {
                selectedDateTime = currentDateTime
            }
        }
    }
}

struct EditReasonSheet: View {
    @State var flowData: BookingFlowData
    @Binding var isPresented: Bool
    @State private var appointmentReason: String = ""
    
    var body: some View {
        NavigationStack {
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
                    Button(action: {
                        flowData.appointmentReason = appointmentReason
                        isPresented = false
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
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("NHSGrey5"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .accessibilityLabel("Close")
                    }
                }
            }
        }
        .onAppear {
            // Pre-fill with current value
            appointmentReason = flowData.appointmentReason
        }
    }
}

struct EditPhoneNumberSheet: View {
    @State var flowData: BookingFlowData
    @Binding var isPresented: Bool
    @State private var selectedPhoneNumber: PhoneNumberOption?
    
    var body: some View {
        NavigationStack {
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
                        
                        VStack(spacing: 0) {
                            ForEach(PhoneNumberOption.allCases) { option in
                                Button(action: {
                                    selectedPhoneNumber = option
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(option.label)
                                                .foregroundColor(.nhsBlack)
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
                    Button(action: {
                        if let phone = selectedPhoneNumber {
                            flowData.selectedPhoneNumber = phone.number
                            isPresented = false
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
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("NHSGrey5"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .accessibilityLabel("Close")
                    }
                }
            }
        }
        .onAppear {
            // Pre-select the current value
            selectedPhoneNumber = PhoneNumberOption.allCases.first { $0.number == flowData.selectedPhoneNumber }
        }
    }
}

// MARK: - Flow step 7: booking confirmed
struct BookingEmbeddedStep7View: View {
    @State var flowData: BookingFlowData
    @Environment(\.dismissToRoot) private var dismissToRoot
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
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
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("What happens next")
                                .font(.title3)
                                .bold()
                            
                            Text("You will be called by your GP surgery at 8:15 on Wednesday, 24 July 2025. Keep your phone with you at all times, and be aware the GP number may be withheld.")
                                .font(.body)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)
                        
                        VStack(alignment: .leading, spacing: 12) {
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
                                    .font(.body)
                                    .foregroundColor(Color.nhsBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.clear)
                                    .cornerRadius(30)
                                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.nhsBlue.opacity(0.5), lineWidth: 1))
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
            
            VStack(spacing: 0) {
                Button(action: {
                    dismissToRoot()
                }) {
                    HStack {
                        Text("Exit this service")
                            .font(.body)
                            .foregroundColor(Color.nhsBlack)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.accentColor.opacity(0.7))
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(30)
                }
                .buttonStyle(.plain)
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .background(Color("NHSGrey5"))
        .environment(flowData)
    }
}



// MARK: - Dismiss to Root Environment Key
private struct DismissToRootKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {
    var dismissToRoot: () -> Void {
        get { self[DismissToRootKey.self] }
        set { self[DismissToRootKey.self] = newValue }
    }
}



// MARK: - Preview
#Preview {
    NavigationStack {
        AppointmentsView()
    }
}
