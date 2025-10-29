import SwiftUI

// Environment key for tracking navigation state
private struct NavigationStateKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isNavigated: Binding<Bool> {
        get { self[NavigationStateKey.self] }
        set { self[NavigationStateKey.self] = newValue }
    }
}
