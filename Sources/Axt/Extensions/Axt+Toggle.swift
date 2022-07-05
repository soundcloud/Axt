import SwiftUI

public extension View {
    func axt_toggle(_ identifier: String) -> some View {
        #if TESTABLE
        let label = dig(for: String.self, in: self) ?? ""
        let _isOn = dig(for: Binding<Bool>.self, in: self)
        // By calling the wrappedValue of the binding, we also make sure
        // SwiftUI does not optimize state updating away for this view, and
        // so that it is ready when used in the `action` block as well.
        let isOn = _isOn?.wrappedValue
        return axt(identifier, label: label, value: isOn, action: { withAnimation { _isOn?.wrappedValue.toggle() } })
        #else
        self
        #endif
    }
}
