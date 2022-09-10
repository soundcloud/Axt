import SwiftUI

struct ConfirmationAlertModifier: ViewModifier {
    @Binding var isPresented: Bool

    let message: String
    let action1: () -> Void
    let action2: () -> Void

    func body(content: Content) -> some View {
        content.alert(isPresented: $isPresented) {
            Alert(
                title: Text(message),
                primaryButton: .default(Text("1"), action: action1),
                secondaryButton: .default(Text("2"), action: action2))
        }
        .testId(insert: "button_1", when: isPresented, label: "1", action: action1)
        .testId(insert: "button_2", when: isPresented, label: "2", action: action2)
    }
}
