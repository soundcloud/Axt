import SwiftUI
import Axt

struct LessMenu: View {
    @State private var isPresented = false

    var body: some View {
        Button("...") { isPresented = true }
            .axt("more_button", .button)
            .sheet(isPresented: $isPresented) {
                MoreMenu()
                    .hostAxtSheet()
            }
    }
}

struct MoreMenu: View {
    var body: some View {
        Text("What's more?")
            .axt("more_text", .text)
    }
}
