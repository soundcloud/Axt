import SwiftUI

public struct NativeView<Content: View, M: Modifier> {
    public let base: M
}
