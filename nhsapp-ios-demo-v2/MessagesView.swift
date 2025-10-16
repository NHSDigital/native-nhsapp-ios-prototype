import SwiftUI
import Combine

// MARK: Model
struct Message: Identifiable, Hashable {
    let id = UUID()
    var sender: String
    var preview: String
    var date: Date
    var isRead: Bool
    var isFlagged: Bool
    var content: String
    
    init(sender: String, preview: String, date: Date, isRead: Bool = false, isFlagged: Bool = false, content: String = "") {
        self.sender = sender
        self.preview = preview
        self.date = date
        self.isRead = isRead
        self.isFlagged = isFlagged
        self.content = content
    }
}

// MARK: Sample Message Data
let sampleMessages: [Message] = [
    .init(sender: "Portland Street Great Westood Surgery",
          preview: "Patient survey reminder. The Patient feedback survey is about to close. Have your say about Portland Street Great Westood Surgery by providing us with your thoughts.",
          date: Calendar.current.date(byAdding: .hour, value: -3, to: .now)!,
          isRead: false,
          content: "Dear Patient,\n\nThe Patient feedback survey is about to close. Have your say about Portland Street Great Westood Surgery by providing us with your thoughts.\n\nYour feedback helps us improve our services.\n\nThank you,\nPortland Street Great Westood Surgery"),
    
    .init(sender: "Range Surgery",
          preview: "Dear Mary, we would like to ask you a few questions about smoking. If you smoke, select SMOKE. If you're an ex smoker, select EX. If you have never smoked, select NEVER.",
          date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!,
          isRead: false,
          content: "Dear Mary,\n\nWe would like to ask you a few questions about smoking.\n\nIf you smoke, select SMOKE.\nIf you're an ex smoker, select EX.\nIf you have never smoked, select NEVER.\n\nYour response helps us provide better care.\n\nBest regards,\nRange Surgery"),
    
    .init(sender: "NHS App",
          preview: "Your next COVID-19 vaccination. I'd like to invite you to get your COVID-19 vaccination this spring.",
          date: Calendar.current.date(byAdding: .day, value: -6, to: .now)!,
          isRead: true,
          content: "Dear Patient,\n\nI'd like to invite you to get your COVID-19 vaccination this spring.\n\nSpring boosters are now available for eligible patients. Book your appointment through the NHS App or contact your GP surgery.\n\nStay protected,\nNHS"),
    
    .init(sender: "Wealden Ridge Surgery",
          preview: "Your digital NHS health check is due by 28 August 2025. This is a free check-up of your health.",
          date: Calendar.current.date(byAdding: .day, value: -8, to: .now)!,
          isRead: true,
          isFlagged: true,
          content: "Dear Patient,\n\nYour digital NHS health check is due by 28 August 2025. This is a free check-up of your health.\n\nPlease complete your health check as soon as possible.\n\nBest regards,\nWealden Ridge Surgery"),
    
        .init(sender: "Range Surgery",
              preview: "Your annual flu vaccination is now due. Protect yourself this winter by booking your appointment today.",
              date: Calendar.current.date(byAdding: .day, value: -2, to: .now)!,
              isRead: false,
              content: "Dear Patient,\n\nYour annual flu vaccination is now due. Protect yourself and others this winter by booking your appointment today.\n\nYou can book via the NHS App or contact Range Surgery directly.\n\nThank you,\nRange Surgery"),

        .init(sender: "Range Surgery",
              preview: "We noticed you haven’t completed your blood pressure check. Please submit your latest reading using our online form.",
              date: Calendar.current.date(byAdding: .day, value: -4, to: .now)!,
              isRead: true,
              content: "Dear Patient,\n\nWe noticed you haven’t completed your blood pressure check yet.\n\nPlease submit your latest reading using our online form or by visiting the practice.\n\nRegular monitoring helps us keep your care up to date.\n\nKind regards,\nRange Surgery"),

        .init(sender: "NHS Digital",
              preview: "Important update: Changes to how your health information is stored and shared. Please review the new data sharing policy.",
              date: Calendar.current.date(byAdding: .day, value: -9, to: .now)!,
              isRead: true,
              isFlagged: true,
              content: "Dear Patient,\n\nWe’ve made important updates to how your health information is securely stored and shared within the NHS.\n\nPlease review the new data sharing policy in the NHS App or visit the NHS Digital website for details.\n\nThank you,\nNHS Digital"),

        .init(sender: "Riverside Surgery",
              preview: "Appointment reminder: You have a blood test booked for Monday 21 October at 9:15 AM.",
              date: Calendar.current.date(byAdding: .hour, value: -10, to: .now)!,
              isRead: false,
              content: "Dear Mary,\n\nThis is a reminder that you have a blood test appointment at Riverside Surgery on **Monday 21 October at 9:15 AM**.\n\nPlease arrive 5 minutes early and bring a form of identification.\n\nIf you need to reschedule, contact the surgery as soon as possible.\n\nKind regards,\nRiverside Surgery")

]

// MARK: Message row
private struct MessageRow: View {
    let message: Message

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Circle()
                .frame(width: 8, height: 8)
                .opacity(message.isRead ? 0 : 1)
                .foregroundStyle(.destructive)

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center) {
                    Text(message.sender)
                        .foregroundStyle(.text)
                        .font(.headline)
                        .lineLimit(1)

                    Spacer()

                    HStack(spacing: 4) {
                        Text(messageListDateString(for: message.date))
                            .font(.subheadline)
                            .foregroundStyle(.textSecondary)
                        Image(systemName: "chevron.right")
                            .font(.subheadline)
                            .foregroundStyle(.textTertiary)
                    }
                }

                HStack(alignment: .top) {
                    Text(message.preview)
                        .font(.subheadline)
                        .foregroundStyle(.textSecondary)
                        .lineLimit(2)

                    if message.isFlagged {
                        Image(systemName: "flag.fill")
                            .imageScale(.small)
                            .foregroundStyle(.warning)
                            .padding(.leading, 2)
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

// MARK: - Date formatting helpers

fileprivate extension DateFormatter {
    static let messageTime: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mma"
        f.amSymbol = "am"
        f.pmSymbol = "pm"
        f.locale = Locale(identifier: "en_GB")
        return f
    }()

    static let messageWeekday: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEEE"
        f.locale = Locale(identifier: "en_GB")
        return f
    }()

    static let messageFull: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMM yyyy"
        f.locale = Locale(identifier: "en_GB")
        return f
    }()
}

fileprivate func messageListDateString(for date: Date, calendar: Calendar = .current) -> String {
    let now = Date()

    if calendar.isDateInToday(date) {
        return DateFormatter.messageTime.string(from: date)
    }

    if calendar.isDateInYesterday(date) {
        return "Yesterday"
    }

    let weekNow  = calendar.component(.weekOfYear, from: now)
    let weekDate = calendar.component(.weekOfYear, from: date)
    let yearNow  = calendar.component(.yearForWeekOfYear, from: now)
    let yearDate = calendar.component(.yearForWeekOfYear, from: date)

    if weekNow == weekDate && yearNow == yearDate {
        return DateFormatter.messageWeekday.string(from: date)
    }

    return DateFormatter.messageFull.string(from: date)
}

// MARK: - Full date format for detail view

fileprivate extension DateFormatter {
    static let messageFullLong: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMMM yyyy"
        f.locale = Locale(identifier: "en_GB")
        return f
    }()
}

fileprivate func messageDetailDateString(for date: Date, calendar: Calendar = .current) -> String {
    let time = DateFormatter.messageTime.string(from: date)

    if calendar.isDateInToday(date) {
        return "Received today at \(time)"
    }

    if calendar.isDateInYesterday(date) {
        return "Received yesterday at \(time)"
    }

    let now = Date()
    let weekNow  = calendar.component(.weekOfYear, from: now)
    let weekDate = calendar.component(.weekOfYear, from: date)
    let yearNow  = calendar.component(.yearForWeekOfYear, from: now)
    let yearDate = calendar.component(.yearForWeekOfYear, from: date)

    if weekNow == weekDate && yearNow == yearDate {
        let weekday = DateFormatter.messageWeekday.string(from: date)
        return "Received on \(weekday) at \(time)"
    }

    let full = DateFormatter.messageFullLong.string(from: date)
    return "Received \(full) at \(time)"
}

// MARK: - Message Detail View
private struct MessageDetailView: View {
    let message: Message
    @EnvironmentObject var messageStore: MessageStore
    @Environment(\.dismiss) var dismiss
    @State private var showingRemoveAlert = false
    
    // Computed property to get current message state
    private var currentMessage: Message {
        messageStore.messages.first(where: { $0.id == message.id }) ?? message
    }

    var body: some View {
        ZStack {
            Color.pageBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(messageDetailDateString(for: message.date))
                            .font(.subheadline)
                            .foregroundStyle(.textSecondary)
                        
                        Spacer()

                        if currentMessage.isFlagged {
                            Image(systemName: "flag.fill")
                                .imageScale(.small)
                                .foregroundStyle(.warning)
                        }
                    }
                    

                    Text(message.content.isEmpty ? message.preview : message.content)
                        .padding(.top, 16)

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle(message.sender)
        .toolbar {
            ToolbarItem {
                Button {
                    if let index = messageStore.messages.firstIndex(where: { $0.id == message.id }) {
                        messageStore.messages[index].isFlagged.toggle()
                    }
                } label: {
                    Label {
                        Text(currentMessage.isFlagged ? "Unflag" : "Flag")
                    } icon: {
                        Image(systemName: currentMessage.isFlagged ? "flag.slash" : "flag")
                    }
                }
            }
            ToolbarItem {
                Button(role: .destructive) {
                    showingRemoveAlert = true
                } label: {
                    Label { Text("Remove") } icon: { Image(systemName: "trash") }
                }
            }
        }
        .alert("Remove message", isPresented: $showingRemoveAlert) {
            Button("Remove", role: .destructive) {
                messageStore.removeMessage(message)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You can restore the message at any time from your removed messages.")
        }
    }
}

// MARK: - Removed Messages View
private struct RemovedMessagesView: View {
    @EnvironmentObject var messageStore: MessageStore
    @State private var selectedMessage: Message?

    var body: some View {
        ZStack {
            Color.pageBackground.ignoresSafeArea()
            
            if messageStore.removedMessages.isEmpty {
                VStack(spacing: 8) {
                    Text("No removed messages.")
                        .font(.body)
                        .foregroundStyle(.textSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(messageStore.removedMessages) { message in
                        MessageRow(message: message)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedMessage = message
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    messageStore.restoreMessage(message)
                                } label: {
                                    Label { Text("Restore") } icon: { Image(systemName: "arrow.uturn.backward") }
                                }.tint(Color.textLink)
                                
                            }
                    }
                    .rowStyle(.grey)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.pageBackground)
                .navigationDestination(item: $selectedMessage) { message in
                    RemovedMessageDetailView(message: message)
                }
            }
        }
        .navigationTitle("Removed messages")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Removed Message Detail View
private struct RemovedMessageDetailView: View {
    let message: Message
    @EnvironmentObject var messageStore: MessageStore
    @Environment(\.dismiss) var dismiss
    
    // Computed property to get current message state from removed messages
    private var currentMessage: Message {
        messageStore.removedMessages.first(where: { $0.id == message.id }) ?? message
    }

    var body: some View {
        ZStack {
            Color.pageBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(messageDetailDateString(for: message.date))
                        .font(.subheadline)
                        .foregroundStyle(.textSecondary)
                        .padding(.bottom, 16)
                        .padding(.top, -16)

                    Text(message.content.isEmpty ? message.preview : message.content)

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle(message.sender)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem {
                Button("Restore") {
                    messageStore.restoreMessage(message)
                    dismiss()
                }
            }
        }
    }
}

// MARK: - Message Store
class MessageStore: ObservableObject {
    @Published var messages: [Message] = sampleMessages
    @Published var removedMessages: [Message] = []
    
    var unreadCount: Int {
        messages.filter { !$0.isRead }.count
    }
    
    func removeMessage(_ message: Message) {
        if let index = messages.firstIndex(where: { $0.id == message.id }) {
            let removed = messages.remove(at: index)
            removedMessages.append(removed)
        }
    }
    
    func restoreMessage(_ message: Message) {
        if let index = removedMessages.firstIndex(where: { $0.id == message.id }) {
            let restored = removedMessages.remove(at: index)
            messages.append(restored)
        }
    }
    
    func permanentlyDelete(_ message: Message) {
        removedMessages.removeAll { $0.id == message.id }
    }
}

// MARK: List + Navigation + Swipe
struct MessagesView: View {
    @EnvironmentObject var messageStore: MessageStore
    @State private var selectedMessage: Message?

    // MARK: Filter
    enum Filter: String, CaseIterable, Identifiable {
        case all = "All"
        case unread = "Unread"
        case flagged = "Flagged"
        var id: Self { self }
    }
    @State private var filter: Filter = .all

    // NEW: Search
    @State private var searchText: String = ""

    // Base filtered list (existing)
    private var filteredMessages: [Message] {
        let baseList: [Message]
        switch filter {
        case .all:
            baseList = messageStore.messages
        case .unread:
            baseList = messageStore.messages.filter { !$0.isRead }
        case .flagged:
            baseList = messageStore.messages.filter { $0.isFlagged }
        }

        // Sort newest first (assuming Message has a `date` property)
        return baseList.sorted { $0.date > $1.date }
    }

    // NEW: Apply search on top of the filter
    private var displayedMessages: [Message] {
        guard !searchText.isEmpty else { return filteredMessages }
        return filteredMessages.filter { msg in
            let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !q.isEmpty else { return true }
            return msg.sender.localizedCaseInsensitiveContains(q)
                || msg.preview.localizedCaseInsensitiveContains(q)
                || msg.content.localizedCaseInsensitiveContains(q)
        }
    }

    // Counts (existing)
    private var unreadCount: Int { messageStore.messages.filter { !$0.isRead }.count }
    private var flaggedCount: Int { messageStore.messages.filter { $0.isFlagged }.count }
    
    private var activeFilterCount: Int {
        switch filter {
        case .all:     return messageStore.messages.count
        case .unread:  return unreadCount
        case .flagged: return flaggedCount
        }
    }
    
    private var unreadSubtitle: String {
        let count = unreadCount
        return count > 0 ? "\(count) unread" : "Updated just now"
    }

    var body: some View {
        NavigationStack {
            if messageStore.messages.isEmpty {
                
                List {
                    // Removed messages link (unchanged)
                    if !messageStore.removedMessages.isEmpty {
                        NavigationLink {
                            RemovedMessagesView()
                        } label: {
                            HStack {
                                Text("Removed messages")
                                    .foregroundStyle(.textSecondary)
                                    .font(.subheadline)
                                Spacer()
                                Text("\(messageStore.removedMessages.count)")
                                    .foregroundStyle(.textSecondary)
                                    .font(.subheadline)
                            }
                        }
                        .rowStyle(.grey)
                        .listRowInsets(EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16))
                    }
                    
                    Section {
                        Text("You have no messages.")
                            .font(.subheadline)
                            .foregroundStyle(.textSecondary)
                            .rowStyle(.grey)
                    }
                    .listRowInsets(EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16))
                    .listSectionSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.pageBackground)
                .navigationTitle("Messages")
                .navigationSubtitle(
                    Text(unreadSubtitle)
                        .font(.title2)
                )
                .navigationBarTitleDisplayMode(.large) // ensures large title
                .toolbar { filterToolbar }
                .searchable( // NEW: shows below the title (large nav bar)
                    text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search messages"
                )
            } else {
                List {
                    // Empty state for current filter + search
                    if displayedMessages.isEmpty {
                        Text(emptyStateText)
                            .foregroundStyle(.textSecondary)
                            .accessibilityAddTraits(.isStaticText)
                            .listRowSeparator(.hidden)
                            .rowStyle(.grey)
                    }
                    
                    // Removed messages link (unchanged)
                    if !messageStore.removedMessages.isEmpty {
                        NavigationLink {
                            RemovedMessagesView()
                        } label: {
                            HStack {
                                Text("Removed messages")
                                    .foregroundStyle(.textSecondary)
                                    .font(.subheadline)
                                Spacer()
                                Text("\(messageStore.removedMessages.count)")
                                    .foregroundStyle(.textSecondary)
                                    .font(.subheadline)
                            }
                        }
                        .rowStyle(.grey)
                        .listRowInsets(EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16))
                    }

                    ForEach(displayedMessages) { message in
                        MessageRow(message: message)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if let i = messageStore.messages.firstIndex(where: { $0.id == message.id }) {
                                    messageStore.messages[i].isRead = true
                                    selectedMessage = messageStore.messages[i]
                                } else {
                                    selectedMessage = message
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    messageStore.removeMessage(message)
                                } label: {
                                    Label { Text("Remove") } icon: { Image(systemName: "trash") }
                                }.tint(.destructive)

                                Button {
                                    if let i = messageStore.messages.firstIndex(of: message) {
                                        messageStore.messages[i].isFlagged.toggle()
                                    }
                                } label: {
                                    Label {
                                        Text(message.isFlagged ? "Unflag" : "Flag")
                                    } icon: {
                                        Image(systemName: message.isFlagged ? "flag.slash" : "flag")
                                    }
                                }.tint(.warning)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    if let i = messageStore.messages.firstIndex(of: message) {
                                        messageStore.messages[i].isRead.toggle()
                                    }
                                } label: {
                                    Label {
                                        Text(message.isRead ? "Mark Unread" : "Mark Read")
                                    } icon: {
                                        Image(systemName: message.isRead ? "envelope.badge" : "envelope.open")
                                    }
                                }
                                .tint(Color.textLink)
                            }
                    }
                    .rowStyle(.grey)

                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .navigationTitle("Messages")
                .navigationSubtitle(
                    Text(unreadSubtitle)
                        .font(.title2)
                )
                .navigationBarTitleDisplayMode(.large) // NEW: keeps search under title
                .background(Color.pageBackground)
                .navigationDestination(item: $selectedMessage) { message in
                    MessageDetailView(message: message)
                }
                .toolbar { filterToolbar }
                .searchable( // NEW
                    text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search messages"
                )
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .animation(.default, value: filter)
                .animation(.default, value: searchText)
            }
        }
    }

    // Friendly empty state text reflecting search + filter
    private var emptyStateText: String {
        if searchText.isEmpty {
            return "No \(filter.rawValue.lowercased()) messages"
        } else {
            return "No results for “\(searchText)” in \(filter.rawValue.lowercased())"
        }
    }

    // MARK: Toolbar
    @ToolbarContentBuilder
    private var filterToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Picker("Filter", selection: $filter) {
                    Label("All", systemImage: "tray")
                        .tag(Filter.all)

                    Label("Unread (\(unreadCount))", systemImage: "envelope.badge")
                        .tag(Filter.unread)

                    Label("Flagged (\(flaggedCount))", systemImage: "flag")
                        .tag(Filter.flagged)
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .symbolRenderingMode(.hierarchical)

                    if filter != .all {
                        Text("\(filter.rawValue)")
                            .font(.subheadline)
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: filter)
                .animation(.easeInOut(duration: 0.2), value: activeFilterCount)
                .accessibilityLabel("Filter messages")
                .accessibilityValue("\(filter.rawValue)")
                .accessibilityHint("Opens menu to change which messages are shown")
            }
        }
    }
}


#Preview {
    MessagesView()
        .environmentObject(MessageStore())
}
