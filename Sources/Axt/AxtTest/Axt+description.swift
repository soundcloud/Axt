import Foundation

#if TESTABLE

extension Axt {
    func describeHierarchy() -> String {
        describeHierarchy(level: 0)
    }

    private func describeHierarchy(level: Int = 0) -> String {
        var description = ""
        let indent = Array(repeating: " ", count: level * 2).joined()
        description += indent + "→ " + describeNode() + "\n"
        for child in children {
            description += child.describeHierarchy(level: level + 1)
        }
        return description
    }

    private func describeNode() -> String {
        var description = id ?? ""
        if let label = self.label {
            description.append(" label=\"" + label + "\"")
        }
        if let value = self.value {
            description.append(" value=" + String(describing: value))
        }
        if action != nil {
            description.append(" action")
        }
        if !visible {
            description.append(" hidden")
        }
        return description
    }
}

#endif
