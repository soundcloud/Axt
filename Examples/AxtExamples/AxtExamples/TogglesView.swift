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
                .axt(.toggle, "toggle_1")
            Toggle("Show more", isOn: $showMore)
                .axt(.toggle, "show_more")
            if showMore {
                Toggle("2", isOn: $value2)
                    .axt(.toggle, "toggle_2")
                Toggle("3", isOn: $value3)
                    .axt(.toggle, "toggle_3")
                Toggle("4", isOn: $value4)
                    .axt(.toggle, "toggle_4")
            }
        }
    }
}
