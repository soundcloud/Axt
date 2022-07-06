import SwiftUI

public struct NavigationLinkModifier<Content: View>: Modifier {
    #if TESTABLE
    public func make(_ content: Content) -> some View {
        let makeContent: (State<Bool>) -> Content = { state in
            // This is modifying the navigation link directly and depends
            // on the fact that the isActive: State<Bool> parameter is the
            // first parameter in the NavigationLink structure.
            var link = content
            withUnsafeMutablePointer(to: &link) { pointer in
                pointer.withMemoryRebound(to: State<Bool>.self, capacity: 1) { statePointer in
                    statePointer.pointee = state
                }
            }
            return link
        }
        return AxtNavigationLink(isActive: dig(for: State<Bool>.self, in: content)!, content: makeContent)
    }
    #endif
}

#if TESTABLE

private struct AxtNavigationLink<Content: View>: View {
    // Because a State variable is only ready once the body is called by
    // SwiftUI, you cannot access State variables from the parent of a view,
    // and they need to be moved up the hierarchy.
    @State var isActive: Bool
    let content: (State<Bool>) -> Content

    init(isActive: State<Bool>, content: @escaping ((State<Bool>) -> Content)) {
        _isActive = isActive
        self.content = content
    }

    var body: some View {
        // Prevents SwiftUI from optimizing state updating away, so that it is
        // ready when used in the `activate` closure.
        // swiftformat:disable:next redundantLet
        let _ = isActive
        content(_isActive)
            .axt {
                isActive.toggle()
            }
    }
}

#endif

public extension NativeView {
    static var navigationLink: NativeView<Content, NavigationLinkModifier<Content>> { .init(base: .init()) }
}
