import Combine
import SwiftUI

#if TESTABLE

public final class AxtTest {
    public let id: UUID = UUID()

    private var window: UIWindow!
    public private(set) var hostingController: UIViewController!

    public internal(set) static var sheets: [UUID: AxtTest] = [:]
    public internal(set) static var enabled = false

    private let axtSubject = CurrentValueSubject<Axt?, Never>(nil)

    public init<V: View>(_ view: V) {
        let host = HostView(content: view, axtSubject: axtSubject)
        hostingController = UIHostingController(rootView: host)
    }

    @MainActor
    public static func host<V: View>(_ view: V) async -> AxtTest {
        let axTest = AxtTest(view)
        axTest.makeWindow()
        _ = await axTest.axtSubject.dropFirst().values.first { _ in true }
        return axTest
    }

    public func makeWindow(size: CGSize? = nil) {
        Self.enabled = true
        let windowScenes = UIApplication.shared.connectedScenes
        guard let scene = windowScenes.first as? UIWindowScene else {
            fatalError("Could not connect to window scene, make sure the test is running from a host application.")
        }
        window = UIWindow(windowScene: scene)
        window.rootViewController = hostingController
        window.layer.borderColor = UIColor.red.cgColor
        window.layer.borderWidth = 5.0
        if let size = size {
            window.frame = CGRect(origin: .zero, size: size)
            window.layer.borderWidth = 2.0
        }
        window.makeKeyAndVisible()
    }

    public var app: AxtElement { self }

    /// Let the current runloop cycle finish.
    /// Most of the time this is enough to let SwiftUI re-evaluate any
    /// properties and views, and can be used instead of waiting with a
    /// time-out.
    public static func yield() async {
        return await withCheckedContinuation { cont in
            DispatchQueue.main.async { [cont] in
                cont.resume()
            }
        }
    }
}

extension AxtTest: AxtNode {
    var nodeId: UUID { axtSubject.value!.nodeId }

    var getRoot: () -> Axt { { self.axtSubject.value! } }

    var rootDidChange: AnyPublisher<Void, Never> { axtSubject.map { _ in }.dropFirst().eraseToAnyPublisher() }
}

private struct HostView<Content: View>: View {
    let content: Content
    let axtSubject: CurrentValueSubject<Axt?, Never>

    var body: some View {
        content
            .axt("app")
            .backgroundPreferenceValue(AxtPreferenceKey.self) {
                // This is used instead of `onPreferenceChange` because that
                // has a safety mechanism that  results in the closure not
                // being called anymore if the preference is updated more than
                // two times before rendering.
                // The safety mechanism prevents infinite loops that can happen
                // when updating a state in response to a preference change,
                // which then causes the preference to be updated again, but we
                // do not need that here.
                let _ = axtSubject.send($0.first)
                Color.clear
            }
    }
}

extension AxtTest: UIViewControllerRepresentable {
    public struct Coordinator {
        let id: UUID
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        AxtTest.sheets[context.coordinator.id] = self
        return hostingController
    }

    public func updateUIViewController(_: UIViewController, context: Context) {
        AxtTest.sheets[context.coordinator.id] = self
    }

    public static func dismantleUIViewController(_: UIViewController, coordinator: Coordinator) {
        AxtTest.sheets.removeValue(forKey: coordinator.id)
    }

    public func makeCoordinator() -> Coordinator { return .init(id: id) }
}

#endif
