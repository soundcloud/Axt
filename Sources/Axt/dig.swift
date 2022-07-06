import Foundation

#if TESTABLE

    /// Recursively search for a property of a specific type in another object.
    /// Works only for value types.
    func dig<T>(for _: T.Type, in object: Any) -> T? {
        if let result = object as? T { return result }

        for child in Mirror(reflecting: object).children {
            if let result = dig(for: T.self, in: child.value) {
                return result
            }
        }

        return nil
    }

#endif
