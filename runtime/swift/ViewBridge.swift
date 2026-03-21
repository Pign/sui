import SwiftUI

/// Protocol for generated views that bridge to Haxe state.
/// In Phase 2+, this connects SwiftUI views to Haxe/C++ state via the bridge.
protocol HaxeView: View {
    func haxeOnAppear()
    func haxeOnDisappear()
}

extension HaxeView {
    func haxeOnAppear() {}
    func haxeOnDisappear() {}
}
