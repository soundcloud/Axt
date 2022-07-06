import SwiftUI

public protocol Modifier {
    associatedtype Content: View
    #if TESTABLE
    associatedtype Body: View
    func make(_ content: Content) -> Body
    #endif
}
