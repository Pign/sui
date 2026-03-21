import SwiftUI

struct ContentView: View {
    @State private var count: Int = 0

    var body: some View {
        VStack {
            Text("Hello")
                .font(.largeTitle)
                .padding()
            Text("Value: \(count)")
                .bold()
            HStack(spacing: 10) {
                Button("-") {
                    count -= 1
                }
                Button("+") {
                    count += 1
                }
            }
            Spacer()
        }
    }
}
