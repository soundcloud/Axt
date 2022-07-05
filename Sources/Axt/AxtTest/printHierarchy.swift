import Foundation

#if TESTABLE

/// For debugging purposes
/// Prints the recursive hierarchy of a Swift structure using `Mirror(reflecting:)`
public func printHierarchy(level: Int = 0, object: Any) {
    let indent = Array(repeating: " ", count: level * 2).joined()
    let mirror = Mirror(reflecting: object)
    print(String(describing: type(of: object)), terminator: "")
    if mirror.children.isEmpty {
        print(" = " + String(describing: object), terminator: "")
    }
    print("")
    for property in mirror.children {
        print(indent + "→ " + (property.label ?? ""), terminator: ": ")
        printHierarchy(level: level + 1, object: property.value)
    }
}

#endif
