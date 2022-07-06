import SwiftUI

struct NativeViews: View {
    @State var counter = 0
    @State var name = ""

    var body: some View {
        List {
            let counterDescription = "Counter: \(counter)"
            Text(counterDescription)
                .axt(.text, "counter_label")
            Button("Tap", action: { counter += 1 })
                .axt(.button, "tap_button")
            NavigationLink("More", destination: Text("More..."))
                .axt(.navigationLink, "more_link")
            TextField("Name", text: $name)
                .axt(.textField, "name_field")
        }

    }
}
