import SwiftUI

public extension NavigationLink {
    func axt_navigation_link(_ identifier: String) -> some View {
        #if TESTABLE
        let makeContent: (State<Bool>) -> Self = { state in
            // This is modifying the navigation link directly and depends
            // on the fact that the isActive: State<Bool> parameter is the
            // first parameter in the NavigationLink structure.
            var link = self
            withUnsafeMutablePointer(to: &link) { pointer in
                pointer.withMemoryRebound(to: State<Bool>.self, capacity: 1) { statePointer in
                    statePointer.pointee = state
                }
            }
            return link
        }
        return AxtNavigationLink(identifier: identifier, isActive: dig(for: State<Bool>.self, in: self)!, content: makeContent)
        #else
        self
        #endif
    }
}

#if TESTABLE

private struct AxtNavigationLink<Content: View>: View {
    // Because a State variable is only ready once the body is called by
    // SwiftUI, you cannot access State variables from the parent of a view,
    // and they need to be moved up the hierarchy.
    @State var isActive: Bool
    let content: (State<Bool>) -> Content
    let identifier: String

    init(identifier: String, isActive: State<Bool>, content: @escaping ((State<Bool>) -> Content)) {
        _isActive = isActive
        self.content = content
        self.identifier = identifier
    }

    var body: some View {
        // Prevents SwiftUI from optimizing state updating away, so that it is
        // ready when used in the `activate` closure.
        // swiftformat:disable:next redundantLet
        let _ = isActive
        content(_isActive)
            .axt(identifier) {
                isActive.toggle()
            }
    }
}

#endif
