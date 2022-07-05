import Combine
import Foundation

#if TESTABLE

protocol AxtNode: AxtElement {
    var nodeId: UUID { get }
    var getRoot: () -> Axt { get }
    var rootDidChange: AnyPublisher<Void, Never> { get }
}

extension AxtNode {
    var axt: Axt! {
        getRoot().find(where: { $0.nodeId == self.nodeId })
    }

    func makeNode(nodeId: UUID) -> AxtChildNode {
        AxtChildNode(nodeId: nodeId, getRoot: getRoot, rootDidChange: rootDidChange)
    }

    public var exists: Bool { axt != nil }

    public var id: String! { axt?.id }

    public var label: String? { axt?.label }

    public var value: Any? { axt?.value }

    public var children: [AxtElement] {
        axt?.children.map { makeNode(nodeId: $0.nodeId) } ?? []
    }

    public var all: [AxtElement] {
        axt?.all.map { makeNode(nodeId: $0.nodeId) } ?? []
    }

    public func find(id: String) -> AxtElement? {
        if let axt = axt?.find(where: { $0.id == id }) {
            return makeNode(nodeId: axt.nodeId)
        }
        return nil
    }

    public func findAll(id: String) -> [AxtElement] {
        (axt?.all ?? []).filter { $0.id == id }.map { makeNode(nodeId: $0.nodeId) }
    }

    public func performAction() {
        axt?.action?()
    }

    public func setValue(_ value: Any?) {
        axt?.setValue?(value)
    }

    public func waitForCondition(timeout: TimeInterval, condition: @escaping () -> Bool) async throws {
        try await rootDidChange.filter { condition() }.firstValue(timeout: timeout)
    }

    public func waitForElement(id: String, timeout: TimeInterval) async throws -> AxtElement {
        let axt = try await rootDidChange.map { self.axt }
            .compactMap { axt in axt.find(where: { child in child.id == id }) }
            .firstValue(timeout: timeout)
        return makeNode(nodeId: axt.nodeId)
    }

    public func waitForUpdate(timeout: TimeInterval) async throws {
        _ = try await rootDidChange.map { self.axt }
            .removeDuplicates()
            .firstValue(timeout: timeout)
    }

    public func watchHierarchy() async {
        for await description in rootDidChange.compactMap({ self.axt?.describeHierarchy() }).prepend([axt.describeHierarchy()]).values {
            print("────────")
            print(description)
        }
    }
}

#endif
