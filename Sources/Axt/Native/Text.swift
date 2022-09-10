import SwiftUI

public struct TextModifier<Content: View>: Modifier {
    #if TESTABLE
    public func make(_ content: Content) -> some View {
        var label: String?
        if let text = dig(for: Text.self, in: content) {
            label = dig(for: String.self, in: text)
        }
        return content.testData(label: label)
    }
    #endif
}

public extension NativeView {
    static var text: NativeView<Content, TextModifier<Content>> { .init(base: .init()) }
}
