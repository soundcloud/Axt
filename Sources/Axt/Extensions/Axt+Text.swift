import SwiftUI

public extension View {
    func axt_text(_ identifier: String) -> some View {
        #if TESTABLE
        let label = dig(for: String.self, in: self) ?? ""
        return axt(identifier, label: label)
        #else
        self
        #endif
    }
}
