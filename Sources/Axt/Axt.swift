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
