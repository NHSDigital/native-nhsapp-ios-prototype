import SwiftUI

// MARK: Model
struct Message: Identifiable, Hashable {
    let id = UUID()
    var sender: String
    var preview: String
    var date: Date = .now
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
                .foregroundStyle(.red)
                .padding(.top, 8)

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                    Text(message.sender)
                        .foregroundStyle(.text)
                        .font(.headline)
                        .lineLimit(1)

                    if message.isFlagged {
                        Image(systemName: "flag.fill")
                            .imageScale(.small)
                            .foregroundStyle(.orange)
                            .padding(.leading, 2)
                    }

                    Spacer()

                    // date + custom chevron
                    HStack(spacing: 4) {
                        Text(message.date, style: .time)
                            .font(.caption)
                            .foregroundStyle(.textSecondary)
                            .padding(.top, 4)
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                            .padding(.top, 4)
                    }
                }

                Text(message.preview)
                    .font(.footnote)
                    .foregroundStyle(.textSecondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

// MARK: Detail
private struct MessageDetailView: View {
    let message: Message

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("From: \(message.sender)")
                .font(.headline)
                .foregroundStyle(.secondary)

            Divider()

            Text(message.preview + "\n\n(Full message body goes here.)")

            Spacer()
        }
        .padding()
        .navigationTitle("Message")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: List + Navigation + Swipe
struct MessagesView: View {
    @State private var messages: [Message] = [
        .init(sender: "Portland Street Great Westood Surgery",
              preview: "Patient survey reminder. The Patient feedback survey is about to close. Have your say about Portland Street Great Westood Surgery by providing us with your thoughts.",
              isRead: false),
        .init(sender: "Range Surgery",
              preview: "Dear Mary, we would like to ask you a few questions about smoking. If you smoke, select SMOKE. If you're an ex smoker, select EX. If you have never smoked, select NEVER.",
              isRead: true, isFlagged: true),
        .init(sender: "NHS App",
              preview: "Your next COVID-19 vaccination. I'd like to invite you to get your COVID-19 vaccination this spring.",
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
                            selectedMessage = message
                        }
                        // trailing swipe (right→left)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                messages.removeAll { $0.id == message.id }
                            } label: {
                                Label {
                                    Text("Delete")
                                } icon: {
                                    Image(systemName: "trash")
                                }
                            }

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
                            }
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
