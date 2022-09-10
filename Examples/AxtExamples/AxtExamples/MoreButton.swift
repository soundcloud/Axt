import SwiftUI
import Axt

struct LessMenu: View {
    @State private var isPresented = false

    var body: some View {
        Button("...") { isPresented = true }
            .testId("more_button", type: .button)
            .sheet(isPresented: $isPresented) {
                MoreMenu()
                    .hostAxtSheet()
            }
    }
}

struct MoreMenu: View {
    var body: some View {
        Text("What's more?")
            .testId("more_text", type: .text)
    }
}
