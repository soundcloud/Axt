import Foundation

#if TESTABLE

/// Recursively search for a property of a specific type in another object.
func dig<T>(for _: T.Type, in object: Any) -> T? {
    if let result = object as? T { return result }

    for child in Mirror(reflecting: object).children {
        if let result = dig(for: T.self, in: child.value) {
            return result
        }
    }

    return nil
}

/// Recursively search for a property with a specific name in another object.
func digForProperty(named name: String, in object: Any) -> Any? {
    for child in Mirror(reflecting: object).children {
        if child.label == name { return child.value }
        if let result = digForProperty(named: name, in: child.value) {
            return result
        }
    }

    return nil
}

#endif
