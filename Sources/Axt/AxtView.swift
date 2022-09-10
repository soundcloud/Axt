import SwiftUI

#if TESTABLE

struct AxtView<Content: View>: View {
    let identifier: String?
    let label: String?
    let value: Any?
    let action: (() -> Void)?
    let setValue: ((Any?) -> Void)?
    let content: Content
    @State private var nodeId = UUID()

    var body: some View {
        content
            .transformPreference(AxtPreferenceKey.self) { value in
                if value.count == 1, let placeholder = value.first, placeholder.id == nil {
                    value = [Axt(id: identifier, nodeId: self.nodeId , label: self.label ?? placeholder.label, value: self.value ?? placeholder.value, action: self.action ?? placeholder.action, setValue: self.setValue ?? placeholder.setValue, children: placeholder.children)]
                } else {
                    value = [Axt(id: identifier, nodeId: self.nodeId, label: label, value: self.value, action: action, setValue: setValue, children: value)]
                }
            }
    }
}

struct AxtInsertView<Content: View>: View {
    let identifier: String
    let condition: Bool
    let label: String?
    let value: Any?
    let action: (() -> Void)?
    let setValue: ((Any?) -> Void)?
    let content: Content
    @State private var nodeId = UUID()

    var body: some View {
        content
            .transformPreference(AxtPreferenceKey.self) { value in
                guard condition else { return }
                value.append(Axt(id: identifier, nodeId: self.nodeId, label: label, value: self.value, action: action, setValue: setValue, children: []))
            }
    }
}

#endif
