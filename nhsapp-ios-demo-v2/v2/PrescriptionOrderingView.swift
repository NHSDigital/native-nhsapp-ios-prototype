import SwiftUI

// MARK: - Flow Data Model
@Observable
class PrescriptionFlowData {
    var selectedPharmacy: PharmacyOption = .wellcare
    var selectedMedicines: Set<MedicineOption> = []
    var additionalInformation: String = ""
}

// MARK: - Supporting Types
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

enum MedicineOption: String, CaseIterable, Identifiable {
    case paracetamol = "Paracetamol"
    case ibuprofen = "Ibuprofen"
    case amoxicillin = "Amoxicillin"
    
    var id: String { rawValue }
    var name: String { rawValue }
    var details: String {
        switch self {
        case .paracetamol: return "500mg tablets • 100 tablets"
        case .ibuprofen: return "200mg tablets • 84 tablets"
        case .amoxicillin: return "250mg capsules • 21 capsules"
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

// MARK: - Flow step 2: Current pharmacy with option to change
struct PrescriptionOrderStep2View: View {
    @State var flowData: PrescriptionFlowData
    @Binding var isPresented: Bool
    @State private var showChangePharmacy = false
    @State private var showCloseAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Your pharmacy")
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
                        VStack(alignment: .leading, spacing: 4) {
                            Text(flowData.selectedPharmacy.name)
                                .foregroundColor(.nhsBlack)
                                .font(.body)
                                .bold()
                            Text(flowData.selectedPharmacy.address)
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        Button(action: {
                            showChangePharmacy = true
                        }) {
                            HStack {
                                Text("Change pharmacy")
                                    .foregroundColor(.nhsBlue)
                                    .font(.body)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.nhsBlue)
                            }
                            .contentShape(Rectangle())
                            .padding()
                        }
                        .buttonStyle(.plain)
                        .background(Color.white)
                    }
                    .background(Color.white)
                    .cornerRadius(30)
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 0) {
                NavigationLink(destination: PrescriptionOrderStep3View(flowData: flowData, isPresented: $isPresented)) {
                    Text("Continue")
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
        .sheet(isPresented: $showChangePharmacy) {
            ChangePharmacySheet(flowData: flowData, isPresented: $showChangePharmacy)
        }
    }
}

// MARK: - Change Pharmacy Sheet
struct ChangePharmacySheet: View {
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
                            flowData.selectedPharmacy = pharmacy
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
            selectedPharmacy = flowData.selectedPharmacy
        }
    }
}

// MARK: - Flow step 3: Select medicines
struct PrescriptionOrderStep3View: View {
    @State var flowData: PrescriptionFlowData
    @Binding var isPresented: Bool
    @State private var selectedMedicines: Set<MedicineOption> = []
    @State private var showCloseAlert = false
    
    var allMedicinesSelected: Bool {
        selectedMedicines.count == MedicineOption.allCases.count
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Which medicines do you want?")
                        .font(.title)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    Text("Select the medicines you need for your repeat prescription.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    VStack(spacing: 0) {
                        // Select all option
                        Button(action: {
                            if allMedicinesSelected {
                                selectedMedicines.removeAll()
                            } else {
                                selectedMedicines = Set(MedicineOption.allCases)
                            }
                        }) {
                            HStack {
                                Text("Select all")
                                    .foregroundColor(.nhsBlack)
                                    .font(.body)
                                    .bold()
                                
                                Spacer()
                                
                                Toggle("", isOn: Binding(
                                    get: { allMedicinesSelected },
                                    set: { isOn in
                                        if isOn {
                                            selectedMedicines = Set(MedicineOption.allCases)
                                        } else {
                                            selectedMedicines.removeAll()
                                        }
                                    }
                                ))
                                .labelsHidden()
                                .tint(Color.nhsGreen)
                            }
                            .contentShape(Rectangle())
                            .padding()
                        }
                        .buttonStyle(.plain)
                        .background(Color.white)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Individual medicines
                        ForEach(MedicineOption.allCases) { option in
                            Button(action: {
                                if selectedMedicines.contains(option) {
                                    selectedMedicines.remove(option)
                                } else {
                                    selectedMedicines.insert(option)
                                }
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(option.name)
                                            .foregroundColor(.nhsBlack)
                                            .font(.body)
                                        Text(option.details)
                                            .foregroundColor(.secondary)
                                            .font(.subheadline)
                                    }
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: Binding(
                                        get: { selectedMedicines.contains(option) },
                                        set: { isOn in
                                            if isOn {
                                                selectedMedicines.insert(option)
                                            } else {
                                                selectedMedicines.remove(option)
                                            }
                                        }
                                    ))
                                    .labelsHidden()
                                    .tint(Color.nhsGreen)
                                }
                                .contentShape(Rectangle())
                                .padding()
                            }
                            .buttonStyle(.plain)
                            .background(Color.white)
                            
                            if option != MedicineOption.allCases.last {
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
                        .background(!selectedMedicines.isEmpty ? Color.nhsGreen : Color.nhsGreen)
                        .cornerRadius(30)
                }
                .buttonStyle(.plain)
                .disabled(selectedMedicines.isEmpty)
                .simultaneousGesture(TapGesture().onEnded {
                    flowData.selectedMedicines = selectedMedicines
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
        .onAppear {
            selectedMedicines = flowData.selectedMedicines
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
                    
                    Text("Please provide any additional information about your prescription request (optional).")
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
                        .background(Color.nhsGreen)
                        .cornerRadius(30)
                }
                .buttonStyle(.plain)
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
        .onAppear {
            additionalInformation = flowData.additionalInformation
        }
    }
}

// MARK: - Flow step 5: Confirm details
struct PrescriptionOrderStep5View: View {
    @State var flowData: PrescriptionFlowData
    @Binding var isPresented: Bool
    @State private var showEditPharmacy = false
    @State private var showEditMedicines = false
    @State private var showEditInformation = false
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
                            showEditPharmacy = true
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Pharmacy")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.gray)
                                    Text(flowData.selectedPharmacy.name)
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
                            showEditMedicines = true
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Medicines")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.gray)
                                    VStack(alignment: .leading, spacing: 2) {
                                        ForEach(Array(flowData.selectedMedicines).sorted(by: { $0.name < $1.name }), id: \.self) { medicine in
                                            Text(medicine.name)
                                                .font(.body)
                                                .foregroundColor(.nhsBlack)
                                        }
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
                        
                        if !flowData.additionalInformation.isEmpty {
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
                NavigationLink(destination: PrescriptionOrderStep6View(flowData: flowData, isPresented: $isPresented)) {
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
        .sheet(isPresented: $showEditPharmacy) {
            ChangePharmacySheet(flowData: flowData, isPresented: $showEditPharmacy)
        }
        .sheet(isPresented: $showEditMedicines) {
            EditMedicinesSheet(flowData: flowData, isPresented: $showEditMedicines)
        }
        .sheet(isPresented: $showEditInformation) {
            EditInformationSheet(flowData: flowData, isPresented: $showEditInformation)
        }
    }
}

// MARK: - Edit Medicines Sheet
struct EditMedicinesSheet: View {
    @State var flowData: PrescriptionFlowData
    @Binding var isPresented: Bool
    @State private var selectedMedicines: Set<MedicineOption> = []
    
    var allMedicinesSelected: Bool {
        selectedMedicines.count == MedicineOption.allCases.count
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Which medicines do you want?")
                            .font(.title)
                            .bold()
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        Text("Select the medicines you need for your repeat prescription.")
                            .font(.body)
                            .foregroundColor(Color.nhsGrey1)
                            .padding(.horizontal)
                            .padding(.top, 8)
                        
                        VStack(spacing: 0) {
                            // Select all option
                            Button(action: {
                                if allMedicinesSelected {
                                    selectedMedicines.removeAll()
                                } else {
                                    selectedMedicines = Set(MedicineOption.allCases)
                                }
                            }) {
                                HStack {
                                    Text("Select all")
                                        .foregroundColor(.nhsBlack)
                                        .font(.body)
                                        .bold()
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: Binding(
                                        get: { allMedicinesSelected },
                                        set: { isOn in
                                            if isOn {
                                                selectedMedicines = Set(MedicineOption.allCases)
                                            } else {
                                                selectedMedicines.removeAll()
                                            }
                                        }
                                    ))
                                    .labelsHidden()
                                    .tint(Color.nhsGreen)
                                }
                                .contentShape(Rectangle())
                                .padding()
                            }
                            .buttonStyle(.plain)
                            .background(Color.nhsWhite)
                            
                            Divider()
                                .padding(.horizontal)
                            
                            // Individual medicines
                            ForEach(MedicineOption.allCases) { option in
                                Button(action: {
                                    if selectedMedicines.contains(option) {
                                        selectedMedicines.remove(option)
                                    } else {
                                        selectedMedicines.insert(option)
                                    }
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(option.name)
                                                .foregroundColor(.nhsBlack)
                                                .font(.body)
                                            Text(option.details)
                                                .foregroundColor(.secondary)
                                                .font(.subheadline)
                                        }
                                        
                                        Spacer()
                                        
                                        Toggle("", isOn: Binding(
                                            get: { selectedMedicines.contains(option) },
                                            set: { isOn in
                                                if isOn {
                                                    selectedMedicines.insert(option)
                                                } else {
                                                    selectedMedicines.remove(option)
                                                }
                                            }
                                        ))
                                        .labelsHidden()
                                        .tint(Color.nhsGreen)
                                    }
                                    .contentShape(Rectangle())
                                    .padding()
                                }
                                .buttonStyle(.plain)
                                .background(Color.nhsWhite)
                                
                                if option != MedicineOption.allCases.last {
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
                        flowData.selectedMedicines = selectedMedicines
                        isPresented = false
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(!selectedMedicines.isEmpty ? Color.nhsGreen : Color.nhsGreen)
                            .cornerRadius(30)
                    }
                    .disabled(selectedMedicines.isEmpty)
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
            selectedMedicines = flowData.selectedMedicines
        }
    }
}

// MARK: - Edit Information Sheet
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
                        
                        Text("Please provide any additional information about your prescription request (optional).")
                            .font(.body)
                            .foregroundColor(Color.nhsGrey1)
                        
                        TextEditor(text: $additionalInformation)
                            .frame(minHeight: 150)
                            .padding(16)
                            .background(Color.nhsWhite)
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
            additionalInformation = flowData.additionalInformation
        }
    }
}

// MARK: - Flow step 6: Request confirmed
struct PrescriptionOrderStep6View: View {
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
                            
                            Text("Your request has been sent to your GP surgery for approval. Once approved, it can take 3 to 5 working days for a pharmacy to prepare your prescription.")
                                .font(.body)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Your request details")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.nhsBlack)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Your chosen pharmacy")
                                        .font(.subheadline)
                                        .foregroundColor(Color.nhsGrey1)
                                    Text(flowData.selectedPharmacy.name)
                                        .font(.body)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Medicines")
                                        .font(.subheadline)
                                        .foregroundColor(Color.nhsGrey1)
                                    VStack(alignment: .leading, spacing: 2) {
                                        ForEach(Array(flowData.selectedMedicines).sorted(by: { $0.name < $1.name }), id: \.self) { medicine in
                                            Text(medicine.name)
                                                .font(.body)
                                        }
                                    }
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
