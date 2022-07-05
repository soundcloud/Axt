import Combine
import Foundation

#if TESTABLE

class AxtChildNode: AxtNode {
    let nodeId: UUID
    let getRoot: () -> Axt
    let rootDidChange: AnyPublisher<Void, Never>

    init(nodeId: UUID, getRoot: @escaping () -> Axt, rootDidChange: AnyPublisher<Void, Never>) {
        self.nodeId = nodeId
        self.getRoot = getRoot
        self.rootDidChange = rootDidChange
    }
}

#endif
