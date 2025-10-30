import SwiftUI

// MARK: - Flow Data Model
@Observable
class PrescriptionFlowData {
    var selectedPrescriptionType: String = ""
    var selectedPharmacy: String = ""
    var additionalInformation: String = ""
    var selectedContactNumber: String = ""
}

// MARK: - Supporting Types
enum PrescriptionType: String, CaseIterable, Identifiable {
    case emergency = "Emergency prescription"
    case urgent = "Urgent prescription (within 24 hours)"
    case repeatPrescription = "Repeat prescription"
    
    var id: String { rawValue }
    var title: String { rawValue }
}

enum PharmacyOption: String, CaseIterable, Identifiable {
    case wellcare = "Wellcare Pharmacy"
    case boots = "Boots Pharmacy"
    case lloyds = "Lloyds Pharmacy"
    
    var id: String { rawValue }
    var name: String { rawValue }
    var address: String {
        switch self {
        case .wellcare: return "123 High Street, London, SE1 1AA"
        case .boots: return "456 Main Road, London, SE1 2BB"
        case .lloyds: return "789 Queen Street, London, SE1 3CC"
        }
    }
}

enum ContactNumberOption: String, CaseIterable, Identifiable {
    case mobile = "Mobile"
    case home = "Home"
    case work = "Work"
    
    var id: String { rawValue }
    var label: String { rawValue }
    var number: String {
        switch self {
        case .mobile: return "07123 456789"
        case .home: return "020 1234 5678"
        case .work: return "020 8765 4321"
        }
    }
}

// MARK: - Flow step 1: Start screen
struct PrescriptionOrderStep1View: View {
    @State private var flowData = PrescriptionFlowData()
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            PrescriptionOrderStep1ContentView(flowData: flowData, isPresented: $isPresented)
        }
    }
}

struct PrescriptionOrderStep1ContentView: View {
    @State var flowData: PrescriptionFlowData
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Request a repeat prescription")
                        .font(.largeTitle)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                
                    Text("Use this service to request a repeat prescription from your GP surgery.")
                        .font(.body)
                        
                    // Inset text component
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.nhsBlue)
                            .frame(width: 8)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Important information")
                                .font(.headline)
                            
                            Text("Please allow 48 hours notice. Your GP may contact you to discuss your request.")
                                .font(.body)
                        }
                        .padding(.leading, 16)
                    }
                    
                    Divider()

                    Text("For urgent medical advice, call 111 or visit 111.nhs.uk")
                        .font(.body)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 0) {
                NavigationLink(destination: PrescriptionOrderStep2View(flowData: flowData, isPresented: $isPresented)) {
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    print("DEBUG: X button tapped, setting isPresented to false")
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .accessibilityLabel("Close")
                }
            }
        }
        .environment(flowData)
    }
}

// MARK: - Flow step 2: Select prescription type
struct PrescriptionOrderStep2View: View {
    @State var flowData: PrescriptionFlowData
    @Binding var isPresented: Bool
    @State private var selectedPrescriptionType: PrescriptionType?
    @State private var showCloseAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Select prescription type")
                    .font(.title)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                    .padding(.top)
                
                List {
                    ForEach(PrescriptionType.allCases) { option in
                        Button(action: {
                            selectedPrescriptionType = option
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(option.title)
                                        .foregroundColor(.nhsBlack)
                                        .font(.body)
                                }
                                
                                Spacer()
                                
                                if selectedPrescriptionType == option {
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
                NavigationLink(destination: PrescriptionOrderStep3View(flowData: flowData, isPresented: $isPresented)) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedPrescriptionType != nil ? Color.nhsGreen : Color.nhsGreen)
                        .cornerRadius(30)
                }
                .buttonStyle(.plain)
                .disabled(selectedPrescriptionType == nil)
                .simultaneousGesture(TapGesture().onEnded {
                    if let selectedType = selectedPrescriptionType {
                        flowData.selectedPrescriptionType = selectedType.title
                    }
                })
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
        .environment(flowData)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showCloseAlert = true
                }) {
                    Image(systemName: "xmark")
                        .accessibilityLabel("Close")
                }
            }
        }
        .alert("Are you sure you want to close this form? Your progress won't be saved.", isPresented: $showCloseAlert) {
            Button("Continue with form", role: .cancel) { }
            Button("Exit form", role: .destructive) {
                print("DEBUG: Setting isPresented to false")
                isPresented = false
            }
        } message: {
            Text("Your progress will not be saved.")
        }
    }
}

// MARK: - Flow step 3: Select pharmacy
struct PrescriptionOrderStep3View: View {
    @State var flowData: PrescriptionFlowData
    @Binding var isPresented: Bool
    @State private var selectedPharmacy: PharmacyOption?
    @State private var showCloseAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Select your pharmacy")
                        .font(.title)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    Text("Your prescription will be sent to this pharmacy.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    VStack(spacing: 0) {
                        ForEach(PharmacyOption.allCases) { option in
                            Button(action: {
                                selectedPharmacy = option
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(option.name)
                                            .foregroundColor(.nhsBlack)
                                            .font(.body)
                                        Text(option.address)
                                            .foregroundColor(.secondary)
                                            .font(.subheadline)
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedPharmacy == option {
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
                            
                            if option != PharmacyOption.allCases.last {
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
                NavigationLink(destination: PrescriptionOrderStep4View(flowData: flowData, isPresented: $isPresented)) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedPharmacy != nil ? Color.nhsGreen : Color.nhsGreen)
                        .cornerRadius(30)
                }
                .buttonStyle(.plain)
                .disabled(selectedPharmacy == nil)
                .simultaneousGesture(TapGesture().onEnded {
                    if let pharmacy = selectedPharmacy {
                        flowData.selectedPharmacy = pharmacy.name
                    }
                })
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
        .environment(flowData)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showCloseAlert = true
                }) {
                    Image(systemName: "xmark")
                        .accessibilityLabel("Close")
                }
            }
        }
        .alert("Are you sure you want to close this form?", isPresented: $showCloseAlert) {
            Button("Continue with form", role: .cancel) { }
            Button("Exit form", role: .destructive) {
                isPresented = false
            }
        } message: {
            Text("Your progress will not be saved.")
        }
    }
}

// MARK: - Flow step 4: Additional information
struct PrescriptionOrderStep4View: View {
    @State var flowData: PrescriptionFlowData
    @Binding var isPresented: Bool
    @State private var additionalInformation: String = ""
    @State private var showCloseAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Additional information")
                        .font(.title)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Please provide details about the medication you need and why this is an emergency request.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    TextEditor(text: $additionalInformation)
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
                NavigationLink(destination: PrescriptionOrderStep5View(flowData: flowData, isPresented: $isPresented)) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(!additionalInformation.isEmpty ? Color.nhsGreen : Color.nhsGreen)
                        .cornerRadius(30)
                }
                .buttonStyle(.plain)
                .disabled(additionalInformation.isEmpty)
                .simultaneousGesture(TapGesture().onEnded {
                    flowData.additionalInformation = additionalInformation
                })
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
        .environment(flowData)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showCloseAlert = true
                }) {
                    Image(systemName: "xmark")
                        .accessibilityLabel("Close")
                }
            }
        }
        .alert("Are you sure you want to close this form?", isPresented: $showCloseAlert) {
            Button("Continue with form", role: .cancel) { }
            Button("Exit form", role: .destructive) {
                isPresented = false
            }
        } message: {
            Text("Your progress will not be saved.")
        }
    }
}

// MARK: - Flow step 5: Select contact number
struct PrescriptionOrderStep5View: View {
    @State var flowData: PrescriptionFlowData
    @Binding var isPresented: Bool
    @State private var selectedContactNumber: ContactNumberOption?
    @State private var showCloseAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Select a contact number")
                        .font(.title)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    Text("We'll call you on this number if we need to contact you about your prescription.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    VStack(spacing: 0) {
                        ForEach(ContactNumberOption.allCases) { option in
                            Button(action: {
                                selectedContactNumber = option
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
                                    
                                    if selectedContactNumber == option {
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
                            
                            if option != ContactNumberOption.allCases.last {
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
                NavigationLink(destination: PrescriptionOrderStep6View(flowData: flowData, isPresented: $isPresented)) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedContactNumber != nil ? Color.nhsGreen : Color.nhsGreen)
                        .cornerRadius(30)
                }
                .buttonStyle(.plain)
                .disabled(selectedContactNumber == nil)
                .simultaneousGesture(TapGesture().onEnded {
                    if let contact = selectedContactNumber {
                        flowData.selectedContactNumber = contact.number
                    }
                })
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("NHSGrey5"))
        .environment(flowData)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showCloseAlert = true
                }) {
                    Image(systemName: "xmark")
                        .accessibilityLabel("Close")
                }
            }
        }
        .alert("Are you sure you want to close this form?", isPresented: $showCloseAlert) {
            Button("Continue with form", role: .cancel) { }
            Button("Exit form", role: .destructive) {
                isPresented = false
            }
        } message: {
            Text("Your progress will not be saved.")
        }
    }
}

// MARK: - Flow step 6: Confirm details
struct PrescriptionOrderStep6View: View {
    @State var flowData: PrescriptionFlowData
    @Binding var isPresented: Bool
    @State private var showEditPrescriptionType = false
    @State private var showEditPharmacy = false
    @State private var showEditInformation = false
    @State private var showEditContactNumber = false
    @State private var showCloseAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Confirm your request details")
                        .font(.title)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Button(action: {
                            showEditPrescriptionType = true
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Prescription type")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.gray)
                                    Text(flowData.selectedPrescriptionType)
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
                            showEditPharmacy = true
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Pharmacy")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.gray)
                                    Text(flowData.selectedPharmacy)
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
                            showEditInformation = true
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Additional information")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.gray)
                                    Text(flowData.additionalInformation)
                                        .font(.body)
                                        .foregroundColor(.nhsBlack)
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
                        .buttonStyle(.plain)
                        
                        Divider()
                        
                        Button(action: {
                            showEditContactNumber = true
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Contact number")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.gray)
                                    Text(flowData.selectedContactNumber)
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
                NavigationLink(destination: PrescriptionOrderStep7View(flowData: flowData, isPresented: $isPresented)) {
                    Text("Confirm request")
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showCloseAlert = true
                }) {
                    Image(systemName: "xmark")
                        .accessibilityLabel("Close")
                }
            }
        }
        .alert("Are you sure you want to close this form?", isPresented: $showCloseAlert) {
            Button("Continue with form", role: .cancel) { }
            Button("Exit form", role: .destructive) {
                isPresented = false
            }
        } message: {
            Text("Your progress will not be saved.")
        }
        .sheet(isPresented: $showEditPrescriptionType) {
            EditPrescriptionTypeSheet(flowData: flowData, isPresented: $showEditPrescriptionType)
        }
        .sheet(isPresented: $showEditPharmacy) {
            EditPharmacySheet(flowData: flowData, isPresented: $showEditPharmacy)
        }
        .sheet(isPresented: $showEditInformation) {
            EditInformationSheet(flowData: flowData, isPresented: $showEditInformation)
        }
        .sheet(isPresented: $showEditContactNumber) {
            EditContactNumberSheet(flowData: flowData, isPresented: $showEditContactNumber)
        }
    }
}

// MARK: - Edit sheets

struct EditPrescriptionTypeSheet: View {
    @State var flowData: PrescriptionFlowData
    @Binding var isPresented: Bool
    @State private var selectedPrescriptionType: PrescriptionType?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Select prescription type")
                        .font(.title)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    List {
                        ForEach(PrescriptionType.allCases) { option in
                            Button(action: {
                                selectedPrescriptionType = option
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(option.title)
                                            .foregroundColor(.nhsBlack)
                                            .font(.body)
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedPrescriptionType == option {
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
                        if let selectedType = selectedPrescriptionType {
                            flowData.selectedPrescriptionType = selectedType.title
                            isPresented = false
                        }
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedPrescriptionType != nil ? Color.nhsGreen : Color.nhsGreen)
                            .cornerRadius(30)
                    }
                    .disabled(selectedPrescriptionType == nil)
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
            selectedPrescriptionType = PrescriptionType.allCases.first { $0.title == flowData.selectedPrescriptionType }
        }
    }
}

struct EditPharmacySheet: View {
    @State var flowData: PrescriptionFlowData
    @Binding var isPresented: Bool
    @State private var selectedPharmacy: PharmacyOption?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Select your pharmacy")
                            .font(.title)
                            .bold()
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        Text("Your prescription will be sent to this pharmacy.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                            .padding(.top, 8)
                        
                        VStack(spacing: 0) {
                            ForEach(PharmacyOption.allCases) { option in
                                Button(action: {
                                    selectedPharmacy = option
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(option.name)
                                                .foregroundColor(.nhsBlack)
                                                .font(.body)
                                            Text(option.address)
                                                .foregroundColor(.secondary)
                                                .font(.subheadline)
                                        }
                                        
                                        Spacer()
                                        
                                        if selectedPharmacy == option {
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
                                
                                if option != PharmacyOption.allCases.last {
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
                        if let pharmacy = selectedPharmacy {
                            flowData.selectedPharmacy = pharmacy.name
                            isPresented = false
                        }
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedPharmacy != nil ? Color.nhsGreen : Color.nhsGreen)
                            .cornerRadius(30)
                    }
                    .disabled(selectedPharmacy == nil)
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
            selectedPharmacy = PharmacyOption.allCases.first { $0.name == flowData.selectedPharmacy }
        }
    }
}

struct EditInformationSheet: View {
    @State var flowData: PrescriptionFlowData
    @Binding var isPresented: Bool
    @State private var additionalInformation: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Additional information")
                            .font(.title)
                            .bold()
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Please provide details about the medication you need and why this is an emergency request.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        TextEditor(text: $additionalInformation)
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
                        flowData.additionalInformation = additionalInformation
                        isPresented = false
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(!additionalInformation.isEmpty ? Color.nhsGreen : Color.nhsGreen)
                            .cornerRadius(30)
                    }
                    .disabled(additionalInformation.isEmpty)
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
            additionalInformation = flowData.additionalInformation
        }
    }
}

struct EditContactNumberSheet: View {
    @State var flowData: PrescriptionFlowData
    @Binding var isPresented: Bool
    @State private var selectedContactNumber: ContactNumberOption?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Select a contact number")
                            .font(.title)
                            .bold()
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        Text("We'll call you on this number if we need to contact you about your prescription.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                            .padding(.top, 8)
                        
                        VStack(spacing: 0) {
                            ForEach(ContactNumberOption.allCases) { option in
                                Button(action: {
                                    selectedContactNumber = option
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
                                        
                                        if selectedContactNumber == option {
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
                                
                                if option != ContactNumberOption.allCases.last {
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
                        if let contact = selectedContactNumber {
                            flowData.selectedContactNumber = contact.number
                            isPresented = false
                        }
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedContactNumber != nil ? Color.nhsGreen : Color.nhsGreen)
                            .cornerRadius(30)
                    }
                    .disabled(selectedContactNumber == nil)
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
            selectedContactNumber = ContactNumberOption.allCases.first { $0.number == flowData.selectedContactNumber }
        }
    }
}

// MARK: - Flow step 7: Request confirmed
struct PrescriptionOrderStep7View: View {
    @State var flowData: PrescriptionFlowData
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Your medicines have been requested")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.nhsGreen)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                        .background(Color.nhsAppPaleGreen)
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
                            
                            Text("YYour request has been sent to your GP surgery for approval. Once approved, it can take 3 to 5 working days for a pharmacy to prepare your prescription.")
                                .font(.body)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Your request details")
                                    .font(.body)
                                    .foregroundColor(Color.nhsGrey1)
                                
                                Text(flowData.selectedPrescriptionType)
                                    .font(.body)
                                    .bold()
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(flowData.selectedPharmacy)
                                        .font(.body)
                                        .bold()
                                    Text("Pharmacy")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Contact number")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(flowData.selectedContactNumber)
                                        .font(.body)
                                }
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
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .background(Color("NHSGrey5"))
        .environment(flowData)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isPresented = false
                }) {
                    Text("Done")
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .tint(.nhsGreen)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    PrescriptionsView()
}
