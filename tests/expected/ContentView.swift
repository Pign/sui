import SwiftUI

struct ContentView: View {
    @Bindable var appState = AppState.shared

    var body: some View {
        VStack {
            Text("Hello")
                .font(.largeTitle)
                .padding()
            Text("Value: \(appState.count)")
                .bold()
            HStack(spacing: 10) {
                Button("-") {
                    Task.detached { HaxeBridgeC.invokeAction(942440246) }
                }
                Button("+") {
                    Task.detached { HaxeBridgeC.invokeAction(1594477690) }
                }
            }
            Spacer()
        }
    }
}
