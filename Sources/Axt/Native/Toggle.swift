import SwiftUI

public struct ToggleModifier<Content: View>: Modifier {
    #if TESTABLE
    public func make(_ content: Content) -> some View {
        let label = dig(for: String.self, in: content) ?? ""
        let isOn: Bool?
        let action: () -> Void
        if #available(iOS 16, *) {
            // Starting with iOS 16, the state of a toggle is no longer a Bool,
            // but an internal enum that can be in an on, off or mixed state.
            let anyToggleStateBinding = digForProperty(named: "_toggleState", in: content)
            let _toggleState = withUnsafePointer(to: anyToggleStateBinding) {
                $0.withMemoryRebound(to: Binding<ToggleState>.self, capacity: 1) {
                    $0.pointee
                }
            }
            switch _toggleState.wrappedValue {
            case .on: isOn = true
            case .off: isOn = false
            case .mixed: isOn = nil
            }
            action = {
                if _toggleState.wrappedValue == .off {
                    _toggleState.wrappedValue = .on
                } else if _toggleState.wrappedValue == .on {
                    _toggleState.wrappedValue = .off
                }
            }
        } else {
            let _isOn = dig(for: Binding<Bool>.self, in: content)
            isOn = _isOn?.wrappedValue
            action = { _isOn?.wrappedValue.toggle() }

        }
        return content.testData(label: label, value: isOn, action: { withAnimation { action() } })
    }
    #endif
}

public extension NativeView {
    static var toggle: NativeView<Content, ToggleModifier<Content>> { .init(base: .init()) }
}

private enum ToggleState {
    case on
    case off
    case mixed
}
