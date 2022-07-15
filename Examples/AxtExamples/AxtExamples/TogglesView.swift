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
                .axt("toggle_1", .toggle)
            Toggle("Show more", isOn: $showMore)
                .axt("show_more", .toggle)
            if showMore {
                Toggle("2", isOn: $value2)
                    .axt("toggle_2", .toggle)
                Toggle("3", isOn: $value3)
                    .axt("toggle_3", .toggle)
                Toggle("4", isOn: $value4)
                    .axt("toggle_4", .toggle)
            }
        }
    }
}
