import SwiftUI

struct NativeViews: View {
    @State var counter = 0
    @State var name = ""

    var body: some View {
        List {
            let counterDescription = "Counter: \(counter)"
            Text(counterDescription)
                .testId("counter_label", type: .text)
            Button("Tap", action: { counter += 1 })
                .testId("tap_button", type: .button)
            NavigationLink("More", destination: Text("More..."))
                .testId("more_link", type: .navigationLink)
            TextField("Name", text: $name)
                .testId("name_field", type: .textField)
        }

    }
}
