import SwiftUI

public struct TextFieldModifier<Content: View>: Modifier {
    #if TESTABLE
    public func make(_ content: Content) -> some View {
        var label: String?
        if let text = dig(for: Text.self, in: content) {
            label = dig(for: String.self, in: text)
        }
        let _value = dig(for: Binding<String>.self, in: content)
        let value = _value?.wrappedValue
        return content.axt(label: label, value: value, setValue: { if let newValue = $0 as? String { _value?.wrappedValue = newValue } })
    }
    #endif
}

public extension NativeView {
    static var textField: NativeView<Content, TextFieldModifier<Content>> { .init(base: .init()) }
}
