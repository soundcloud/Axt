import Foundation
import SwiftUI
import Axt

struct TogglesView: View {
    @State var showMore = false

    @State var value1 = false
    @State var value2 = false
    @State var value3 = false
    @State var value4 = false

    var body: some View {
        List {
            Toggle("1", isOn: $value1)
                .testId("toggle_1", type: .toggle)
            Toggle("Show more", isOn: $showMore)
                .testId("show_more", type: .toggle)
            if showMore {
                Toggle("2", isOn: $value2)
                    .testId("toggle_2", type: .toggle)
                Toggle("3", isOn: $value3)
                    .testId("toggle_3", type: .toggle)
                Toggle("4", isOn: $value4)
                    .testId("toggle_4", type: .toggle)
            }
        }
    }
}
