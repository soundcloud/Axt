import SwiftUI

public struct ButtonModifier<Content: View>: Modifier {
    #if TESTABLE
    public func make(_ content: Content) -> some View {
        var action: (() -> Void)?
        let label = dig(for: String.self, in: content) ?? ""
        // Supresses a compiler warning
        typealias Void_ = Void
        // This type is used in `Button`
        if let buttonAction = dig(for: (() -> Void).self, in: content) {
            action = buttonAction
            // This type is used in tap gestures
        } else if let tapAction = dig(for: ((Void_) -> Void).self, in: content) {
            action = { tapAction(()) }
        }
        return content.axt(label: label, value: nil, action: action)
    }
    #endif
}

public extension NativeView {
    static var button: NativeView<Content, ButtonModifier<Content>> { .init(base: .init()) }
}
