import SwiftUI

public extension View {
    /// Use this modifier on the content **inside** of a sheet, so that the
    /// contents can be accessed using `AXTest.sheets`.
    func hostAxSheet() -> some View {
        #if TESTABLE
        let sheet = AxtTest(self)
        return sheet
        #else
        self
        #endif
    }
}
