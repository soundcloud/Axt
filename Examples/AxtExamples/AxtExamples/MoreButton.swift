import SwiftUI
import Axt

struct LessMenu: View {
    @State private var isPresented = false

    var body: some View {
        Button("...") { isPresented = true }
            .axt(.button, "more_button")
            .sheet(isPresented: $isPresented) {
                MoreMenu()
                    .hostAxSheet()
            }
    }
}

struct MoreMenu: View {
    var body: some View {
        Text("What's more?")
            .axt(.text, "more_text")
    }
}
