import Foundation
import Observation

/// Swift-side bridge for calling into Haxe/C++ code.
/// Provides a high-level API for Swift/SwiftUI code to interact with Haxe business logic.
@Observable
public final class HaxeBridge {
    public static let shared = HaxeBridge()

    /// Registry of action callbacks by name.
    private var actions: [String: () -> Void] = [:]

    /// Registry of value getters by name.
    private var valueGetters: [String: () -> Any] = [:]

    private init() {}

    // MARK: - Action Dispatch

    /// Register a named action that can be invoked from generated SwiftUI code.
    public func registerAction(_ name: String, handler: @escaping () -> Void) {
        actions[name] = handler
    }

    /// Invoke a registered action by name. Called from generated Button handlers etc.
    public func invokeAction(_ name: String) {
        if let action = actions[name] {
            action()
        }
    }

    // MARK: - State Bridge

    /// Get a value from the Haxe/C++ side by key.
    public func getValue<T>(_ key: String) -> T? {
        guard let getter = valueGetters[key] else { return nil }
        return getter() as? T
    }

    /// Register a value getter that reads from the Haxe/C++ side.
    public func registerValueGetter(_ key: String, getter: @escaping () -> Any) {
        valueGetters[key] = getter
    }
}
