import SwiftUI

enum ProfileOption: String, CaseIterable, Identifiable {
    case self_ = "Yourself"
    case spouse = "Spouse"
    case child = "Child"
    
    var id: String { self.rawValue }
    
    var name: String {
        switch self {
        case .self_: return "Shivaya Patel-Jones"
        case .spouse: return "Alex Patel-Jones"
        case .child: return "Maya Patel-Jones"
        }
    }
    
    var nhsNumber: String {
        switch self {
        case .self_: return "123 567 890"
        case .spouse: return "234 678 901"
        case .child: return "345 789 012"
        }
    }
    
    var age: String {
        switch self {
        case .self_: return "46 years old (you)"
        case .spouse: return "44 years old (your spouse)"
        case .child: return "12 years old (your child)"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .self_: return Color("NHSBlue")
        case .spouse: return Color("NHSPurple")
        case .child: return Color("NHSGreen")
        }
    }
    
    var messageCount: Int {
        switch self {
        case .self_: return 3
        case .spouse: return 1
        case .child: return 5
        }
    }
}
