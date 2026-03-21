import SwiftUI

@main
struct TestSwiftGenApp: App {
    init() {
        HaxeRuntime.initialize()
    }

    var body: some Scene {
        WindowGroup("TestApp") {
            ContentView()
        }
    }
}
