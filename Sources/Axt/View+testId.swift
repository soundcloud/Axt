import SwiftUI

public extension View {
    @ViewBuilder func testId<M: Modifier>(_ identifier: String, type: NativeView<Self, M>, label: String? = nil, value: Any? = nil, action: (() -> Void)? = nil, setValue: ((Any?) -> Void)? = nil) -> some View where M.Content == Self {
        #if TESTABLE
        if AxtTest.enabled {
            AxtView(
                identifier: identifier,
                label: label,
                value: value,
                action: action,
                setValue: setValue,
                content: type.base.make(self)
            )
        } else { self }
        #else
        self
        #endif
    }

    @ViewBuilder func testId(_ identifier: String, label: String? = nil, value: Any? = nil, action: (() -> Void)? = nil, setValue: ((Any?) -> Void)? = nil) -> some View {
        #if TESTABLE
        if AxtTest.enabled {
            AxtView(
                identifier: identifier,
                label: label,
                value: value,
                action: action,
                setValue: setValue,
                content: self
            )
        } else { self }
        #else
        self
        #endif
    }

    @ViewBuilder func testId(insert identifier: String, when condition: Bool = true, label: String? = nil, value: Any? = nil, action: (() -> Void)? = nil, setValue: ((Any?) -> Void)? = nil) -> some View {
        #if TESTABLE
        if AxtTest.enabled {
            AxtInsertView(
                identifier: identifier,
                condition: condition,
                label: label,
                value: value,
                action: action,
                setValue: setValue,
                content: self
            )
        } else { self }
        #else
        self
        #endif
    }
}
