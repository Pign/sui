import Foundation

/// Initializes and manages the hxcpp runtime lifecycle.
/// Automatically detects whether the C++ bridge is linked.
public final class HaxeRuntime {
    private static var isInitialized = false

    /// Initialize the hxcpp runtime. Safe to call multiple times (idempotent).
    public static func initialize() {
        guard !isInitialized else { return }

        // Check if haxe_bridge_init exists (linked from hxcpp static library).
        if let bridgeInit = dlsym(dlopen(nil, RTLD_LAZY), "haxe_bridge_init") {
            typealias InitFunc = @convention(c) () -> Void
            let initFn = unsafeBitCast(bridgeInit, to: InitFunc.self)
            initFn()

            // Register state callback if available
            if let registerCb = dlsym(dlopen(nil, RTLD_LAZY), "haxe_bridge_register_state_callback") {
                // HaxeBridgeC.registerCallbacks() handles this
                // It's called from generated code — the existence check here
                // is just for safety.
            }
        }

        isInitialized = true
    }

    /// Shutdown the hxcpp runtime.
    public static func shutdown() {
        guard isInitialized else { return }
        isInitialized = false
    }
}
