import SwiftUI

public struct Axt: Equatable {
    public static func == (lhs: Axt, rhs: Axt) -> Bool {
        lhs._uuid == rhs._uuid
    }

    /// Changes every time the Axt is re-evaluated
    public let _uuid = UUID()

    /// User-defined identifier
    public let id: String?

    /// Unique, does not change when Axt is re-evaluated
    public let nodeId: UUID

    public let label: String?
    public let value: Any?
    public let action: (() -> Void)?
    public let setValue: ((Any?) -> Void)?
    public let children: [Axt]
}

public struct AxtPreferenceKey: PreferenceKey {
    public static var defaultValue: [Axt] = []

    public static func reduce(value: inout [Axt], nextValue: () -> [Axt]) {
        value.append(contentsOf: nextValue())
    }
}

public extension View {
    func axt<M: Modifier>(_ modifier: NativeView<Self, M>, _ identifier: String? = nil, label: String? = nil, value: Any? = nil, action: (() -> Void)? = nil, setValue: ((Any?) -> Void)? = nil) -> some View where M.Content == Self {
        #if TESTABLE
            AxtView(
                identifier: identifier,
                label: label,
                value: value,
                action: action,
                setValue: setValue,
                content: modifier.base.make(self)
            )
        #else
            self
        #endif
    }

    func axt(_ identifier: String? = nil, label: String? = nil, value: Any? = nil, action: (() -> Void)? = nil, setValue: ((Any?) -> Void)? = nil) -> some View {
        #if TESTABLE
            AxtView(
                identifier: identifier,
                label: label,
                value: value,
                action: action,
                setValue: setValue,
                content: self
            )
        #else
            self
        #endif
    }
}

#if TESTABLE

struct AxtView<Content: View>: View {
    let identifier: String?
    let label: String?
    let value: Any?
    let action: (() -> Void)?
    let setValue: ((Any?) -> Void)?
    let content: Content
    @State private var nodeId = UUID()

    var body: some View {
        content
            .transformPreference(AxtPreferenceKey.self) { value in
                if value.count == 1, let placeholder = value.first, placeholder.id == nil {
                    value = [Axt(id: identifier, nodeId: self.nodeId , label: self.label ?? placeholder.label, value: self.value ?? placeholder.value, action: self.action ?? placeholder.action, setValue: self.setValue ?? placeholder.setValue, children: placeholder.children)]
                } else {
                    value = [Axt(id: identifier, nodeId: self.nodeId, label: label, value: self.value, action: action, setValue: setValue, children: value)]
                }
            }
    }
}

#endif
