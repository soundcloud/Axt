import SwiftUI

struct CustomControls: View {
    @State var counter = 0

    var body: some View {
        MyButton() { counter += 1 }
            .axt("my_button")
            .axt(insert: "counter", value: counter)
    }

}

struct MyButton: View {
    let action: () -> Void

    var body: some View {
        Button("Tap me") { action() }
            .axt(action: action)
    }
}
