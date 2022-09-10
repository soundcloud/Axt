import Combine
import SwiftUI

#if TESTABLE

/// Automatically updated when the view it refers to changes
public protocol AxtElement {
    var exists: Bool { get }
    var id: String! { get }
    var label: String? { get }
    var value: Any? { get }

    var children: [AxtElement] { get }
    var all: [AxtElement] { get }
    /// Recursively search for an element
    func find(id: String) -> AxtElement?
    func findAll(id: String) -> [AxtElement]

    func performActionWithoutYielding()
    func setValue(_ value: Any?)

    func waitForCondition(timeout: TimeInterval, condition: @escaping () -> Bool) async throws
    func waitForElement(id: String, timeout: TimeInterval) async throws -> AxtElement
    func waitForUpdate(timeout: TimeInterval) async throws

    func watchHierarchy() async
}

public extension AxtElement {
    func performAction() async {
        performActionWithoutYielding()
        await AxtTest.yield()
    }
}

#endif
