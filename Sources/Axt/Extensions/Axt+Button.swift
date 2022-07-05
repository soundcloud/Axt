import SwiftUI

public extension View {
    func axt_button(_ identifier: String) -> some View {
        #if TESTABLE
        var action: (() -> Void)?
        let label = dig(for: String.self, in: self) ?? ""
        // Supresses a compiler warning
        typealias Void_ = Void
        // This type is used in `Button`
        if let buttonAction = dig(for: (() -> Void).self, in: self) {
            action = buttonAction
            // This type is used in tap gestures
        } else if let tapAction = dig(for: ((Void_) -> Void).self, in: self) {
            action = { tapAction(()) }
        }
        return axt(identifier, label: label, value: nil, action: action)
        #else
        self
        #endif
    }
}
