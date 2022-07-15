import SwiftUI

struct NativeViews: View {
    @State var counter = 0
    @State var name = ""

    var body: some View {
        List {
            let counterDescription = "Counter: \(counter)"
            Text(counterDescription)
                .axt("counter_label", .text)
            Button("Tap", action: { counter += 1 })
                .axt("tap_button", .button)
            NavigationLink("More", destination: Text("More..."))
                .axt("more_link", .navigationLink)
            TextField("Name", text: $name)
                .axt("name_field", .textField)
        }

    }
}
