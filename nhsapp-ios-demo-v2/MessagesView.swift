import SwiftUI

// MARK: Model
struct Message: Identifiable, Hashable {
    let id = UUID()
    var sender: String
    var preview: String
    var date: Date
    var isRead = false
    var isFlagged = false
}

// MARK: Row
private struct MessageRow: View {
    let message: Message

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .frame(width: 8, height: 8)
                .opacity(message.isRead ? 0 : 1)
                .foregroundStyle(.destructive)
                .padding(.top, 8)

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                    Text(message.sender)
                        .foregroundStyle(.text)
                        .font(.headline)
                        .lineLimit(1)

                    Spacer()

                    // date + custom chevron
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

    // Same week check (ISO week)
    let weekNow  = calendar.component(.weekOfYear, from: now)
    let weekDate = calendar.component(.weekOfYear, from: date)
    let yearNow  = calendar.component(.yearForWeekOfYear, from: now)
    let yearDate = calendar.component(.yearForWeekOfYear, from: date)

    if weekNow == weekDate && yearNow == yearDate {
        return DateFormatter.messageWeekday.string(from: date)
    }

    return DateFormatter.messageFull.string(from: date)
}

// MARK: - Preferred full date format for detail view

fileprivate extension DateFormatter {
    static let messageFullLong: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMMM yyyy"      // e.g. "4 October 2023"
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

    // Same ISO week as 'now'
    let now = Date()
    let weekNow  = calendar.component(.weekOfYear, from: now)
    let weekDate = calendar.component(.weekOfYear, from: date)
    let yearNow  = calendar.component(.yearForWeekOfYear, from: now)
    let yearDate = calendar.component(.yearForWeekOfYear, from: date)

    if weekNow == weekDate && yearNow == yearDate {
        let weekday = DateFormatter.messageWeekday.string(from: date) // e.g. "Thursday"
        return "Received on \(weekday) at \(time)"
    }

    let full = DateFormatter.messageFullLong.string(from: date) // e.g. "4 October 2023"
    return "Received \(full) at \(time)"
}

// MARK: Detail
private struct MessageDetailView: View {
    let message: Message

    var body: some View {
        ZStack {
            Color.pageBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(messageDetailDateString(for: message.date))
                        .font(.subheadline)
                        .foregroundStyle(.textSecondary)

                    Text(message.preview + "\n\n(Full message body goes here.)")

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .scrollIndicators(.hidden) // optional
        }
        .navigationTitle(message.sender)

    }
}

// MARK: List + Navigation + Swipe
struct MessagesView: View {
    @State private var messages: [Message] = [
        .init(sender: "Portland Street Great Westood Surgery",
              preview: "Patient survey reminder. The Patient feedback survey is about to close. Have your say about Portland Street Great Westood Surgery by providing us with your thoughts.",
              date: Calendar.current.date(byAdding: .hour, value: -3, to: .now)!,
              isRead: false),
        .init(sender: "Range Surgery",
              preview: "Dear Mary, we would like to ask you a few questions about smoking. If you smoke, select SMOKE. If you're an ex smoker, select EX. If you have never smoked, select NEVER.",
              date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!,
              isRead: true, isFlagged: true),
        .init(sender: "NHS App",
              preview: "Your next COVID-19 vaccination. I'd like to invite you to get your COVID-19 vaccination this spring.",
              date: Calendar.current.date(byAdding: .day, value: -6, to: .now)!,
              isRead: false)
    ]

    @State private var selectedMessage: Message?

    var body: some View {
        NavigationStack {
            
            List {
                ForEach(messages) { message in
                    // row wrapped in a manual navigation trigger
                    MessageRow(message: message)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // mark as read immediately
                            if let i = messages.firstIndex(where: { $0.id == message.id }) {
                                messages[i].isRead = true
                                selectedMessage = messages[i] // navigate to the updated message
                            } else {
                                selectedMessage = message
                            }
                        }
                        // trailing swipe (right→left)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                messages.removeAll { $0.id == message.id }
                            } label: {
                                Label { Text("Delete") } icon: { Image(systemName: "trash") }
                            }.tint(.destructive)

                            Button {
                                if let i = messages.firstIndex(of: message) {
                                    messages[i].isFlagged.toggle()
                                }
                            } label: {
                                Label {
                                    Text(message.isFlagged ? "Unflag" : "Flag")
                                } icon: {
                                    Image(systemName: message.isFlagged ? "flag.slash" : "flag")
                                }
                            }.tint(.warning)
                        }
                        // leading swipe (left→right)
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                if let i = messages.firstIndex(of: message) {
                                    messages[i].isRead.toggle()
                                }
                            } label: {
                                Label {
                                    Text(message.isRead ? "Mark Unread" : "Mark Read")
                                } icon: {
                                    Image(systemName: message.isRead ? "envelope.badge" : "envelope.open")
                                }
                            }
                            .tint(.blue)
                        }
                }
                .rowStyle(.white)
                .listSectionSeparator(.hidden, edges: .top)
                .listSectionSeparator(.hidden, edges: .bottom)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .navigationTitle("Messages")
            .background(Color.pageBackground)
            // manual destination
            .navigationDestination(item: $selectedMessage) { message in
                MessageDetailView(message: message)
            }
        }
    }
}

#Preview { MessagesView() }
