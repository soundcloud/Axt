import SwiftUI

public struct ToggleModifier<Content: View>: Modifier {
    #if TESTABLE
    public func make(_ content: Content) -> some View {
        let label = dig(for: String.self, in: content) ?? ""
        let _isOn = dig(for: Binding<Bool>.self, in: content)
        // By calling the wrappedValue of the binding, we also make sure
        // SwiftUI does not optimize state updating away for this view, and
        // so that it is ready when used in the `action` block as well.
        let isOn = _isOn?.wrappedValue
        return content.testData(label: label, value: isOn, action: { withAnimation { _isOn?.wrappedValue.toggle() } })
    }
    #endif
}

public extension NativeView {
    static var toggle: NativeView<Content, ToggleModifier<Content>> { .init(base: .init()) }
}
