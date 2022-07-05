import Foundation

#if TESTABLE

extension Axt {
    func find(where condition: (Axt) -> Bool) -> Axt? {
        if condition(self) { return self }
        for child in children {
            if let match = child.find(where: condition) {
                return match
            }
        }
        return nil
    }

    var all: [Axt] {
        var all: [Axt] = []
        for child in children {
            all.append(child)
            all.append(contentsOf: child.all)
        }
        return all
    }
}

#endif
