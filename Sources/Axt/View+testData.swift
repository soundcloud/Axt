import SwiftUI

public extension View {
    @ViewBuilder func testData<M: Modifier>(type: NativeView<Self, M>, label: String? = nil, value: Any? = nil, action: (() -> Void)? = nil, setValue: ((Any?) -> Void)? = nil) -> some View where M.Content == Self {
        #if TESTABLE
        if AxtTest.enabled {
            AxtView(
                identifier: nil,
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

    @ViewBuilder func testData(label: String? = nil, value: Any? = nil, action: (() -> Void)? = nil, setValue: ((Any?) -> Void)? = nil) -> some View {
        #if TESTABLE
        if AxtTest.enabled {
            AxtView(
                identifier: nil,
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
