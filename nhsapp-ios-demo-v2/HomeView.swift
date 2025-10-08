import SwiftUI

struct HomeView: View {

    // Use an Identifiable item so the cover only shows when non-nil
    struct LinkItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let url: URL
    }

    @State private var selectedLink: LinkItem? = nil

    // State variables for toggle examples
    @State private var toggleOne = true
    @State private var toggleTwo = false

    var body: some View {
        NavigationStack {
            List {

                // Simple text row with header and footer
                Section {
                    Text("Text row 1")
                    Text("Text row 2")
                    Text("Text row 3")
                } header: {
                    Text("Section header")
                } footer: {
                    Text("Footer text explaining something.")
                        .foregroundStyle(.TextSecondary)
                }

                // Custom row with title and subtitle
                Section {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Main title")
                                .font(.title2)

                            Text("Subtitle or description text")
                                .font(.subheadline)
                                .foregroundStyle(.TextSecondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                // Navigation links
                Section {
                    NavigationLink("Link 1") { DetailView(index: 0) }
                    NavigationLink("Link 2") { DetailView(index: 1) }
                    NavigationLink("Link 3") { DetailView(index: 3) }
                }

                // External link row (single)
                Section {
                    ExternalLinkRow(title: "Website",
                                    url: URL(string: "https://111.nhs.uk/")!) { url in
                        selectedLink = LinkItem(title: "Website", url: url)
                    }
                }

                // External link rows (multiple)
                Section {
                    ExternalLinkRow(title: "NHS 111",
                                    url: URL(string: "https://111.nhs.uk/")!) { url in
                        selectedLink = LinkItem(title: "NHS 111", url: url)
                    }
                    ExternalLinkRow(title: "NHS Website",
                                    url: URL(string: "https://www.nhs.uk")!) { url in
                        selectedLink = LinkItem(title: "NHS Website", url: url)
                    }
                }

                // Custom row that is also a navigation link
                Section {
                    NavigationLink {
                        DetailView(index: 4)
                    } label: {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Main title")
                                Text("Subtitle or description text")
                                    .font(.subheadline)
                                    .foregroundStyle(.TextSecondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                // Custom row with title, subtitle and a navigation link
                Section {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Main title")
                                .font(.title)
                                .bold()

                            Text("Subtitle or description text")
                                .font(.subheadline)
                                .foregroundStyle(.TextSecondary)
                        }
                    }
                    .padding(.vertical, 4)
                    NavigationLink("Link") { DetailView(index: 5) }
                }

                // Custom row with title, subtitle and a navigation link
                Section {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Main title")
                                .font(.title)
                                .bold()
                            Text("Subtitle or description text")
                                .font(.subheadline)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    NavigationLink("Link") { DetailView(index: 6) }
                }
                .foregroundStyle(Color("NHSAppDarkBlue"))
                .listRowBackground(Color("NHSAppPaleBlue"))
                

                // Buttons
                Section {
                    Button("Button") { }
                }

                Section {
                    Button("Button cancel", role: .cancel) { }
                }

                Section {
                    Button("Button desctructive", role: .destructive) { }
                }

                // A mixture of all the above
                Section("All of the above") {
                    Text("Text row")
                    NavigationLink("Link") { DetailView(index: 0) }
                    Button("Button") { }
                    Button("Button cancel", role: .cancel) { }
                    Button("Button desctructive", role: .destructive) { }
                }

                // Toggles
                Section {
                    Toggle("Toggle 1", isOn: $toggleOne)
                        .onChange(of: toggleOne) { oldValue, newValue in
                            print("Notifications: \(oldValue) → \(newValue)")
                        }
                    Toggle("Toggle 2", isOn: $toggleTwo)
                        .onChange(of: toggleTwo) { oldValue, newValue in
                            print("Notifications: \(oldValue) → \(newValue)")
                        }
                }

                // Custom NHS buttons
                NHSButton(title: "Primary button", style: .primary) { }
                NHSButton(title: "Secondary button", style: .secondary) { }
                NHSButton(title: "Tertiary button", style: .tertiary) { }
                NHSButton(title: "Warning button", style: .warning) { }
                NHSButton(title: "Destructive button", style: .destructive) { }

                // Rows with trailing elements
                Section {
                    HStack {
                        Text("Text row 1")
                        Spacer()
                        Text("Trailing")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Text row 2")
                        Spacer()
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }

                    HStack {
                        Text("Appointment Reminder")
                        Spacer()
                        Button("Edit") {
                            // Action
                        }
                    }

                    HStack {
                        Text("Uploading")
                        Spacer()
                        ProgressView()
                    }

                    HStack {
                        Text("Date picker")
                        Spacer()
                        DatePicker("", selection: .constant(Date()), displayedComponents: .date)
                            .labelsHidden()
                            .datePickerStyle(.compact)
                    }

                    HStack {
                        Text("Date + time pickers")
                        Spacer()
                        HStack(spacing: 8) {
                            DatePicker("", selection: .constant(Date()), displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(.compact)
                            DatePicker("", selection: .constant(Date()), displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(.compact)
                        }
                    }

                    HStack {
                        Text("Time-only picker")
                        Spacer()
                        DatePicker("", selection: .constant(Date()), displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(.compact)
                    }

                    HStack {
                        Text("Pop-up picker")
                        Spacer()
                        Picker("Pop-up", selection: .constant("Option 1")) {
                            Text("Option 1").tag("Option 1")
                            Text("Option 2").tag("Option 2")
                            Text("Option 3").tag("Option 3")
                        }
                        .pickerStyle(.menu)
                        .frame(width: 120)
                    }

                    HStack {
                        Text("Stepper")
                        Spacer()
                        Stepper("", value: .constant(1), in: 0...10)
                            .labelsHidden()
                            .frame(width: 100)
                    }

                } header: {
                    Text("Trailing elements")
                }

            }
            // Present only when selectedLink != nil
            .fullScreenCover(item: $selectedLink) { link in
                SafariView(url: link.url)
                    .ignoresSafeArea()
            }
            .navigationTitle("Lists")
            .nhsListStyle()
        }
        .background(Color.PageBackground)
    }
}

#Preview {
    HomeView()
}
