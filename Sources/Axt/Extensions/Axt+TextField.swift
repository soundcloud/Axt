import SwiftUI

public extension View {
    func axt_text_field(_ identifier: String) -> some View {
        #if TESTABLE
        var label: String?
        if let text = dig(for: Text.self, in: self) {
            label = dig(for: String.self, in: text)
        }
        let _value = dig(for: Binding<String>.self, in: self)
        let value = _value?.wrappedValue
        return axt(identifier, label: label, value: value, setValue: { if let newValue = $0 as? String { _value?.wrappedValue = newValue } })
        #else
        self
        #endif
    }
}
