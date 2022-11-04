import SwiftUI

public extension View {
    /// Use this modifier on the content **inside** of a sheet, so that the
    /// contents can be accessed using `AXTest.sheets`.
    func hostAxtSheet() -> some View {
        #if TESTABLE
        AxtSheet(content: self)
        #else
        self
        #endif
    }
}

#if TESTABLE

struct AxtSheet<Content: View>: UIViewControllerRepresentable {
    let content: Content

    public struct Coordinator {
        let id: UUID
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        let test = AxtTest(content)
        AxtTest.sheets[context.coordinator.id] = test
        return test.hostingController
    }

    public func updateUIViewController(_: UIViewController, context: Context) {
        let test = AxtTest.sheets[context.coordinator.id]
        (test?.hostingController as? UIHostingController<Content>)?.rootView = content
    }

    public static func dismantleUIViewController(_: UIViewController, coordinator: Coordinator) {
        AxtTest.sheets.removeValue(forKey: coordinator.id)
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(id: UUID())
    }
}

#endif
