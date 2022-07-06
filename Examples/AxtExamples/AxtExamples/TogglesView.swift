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
            Toggle("Show more", isOn: $showMore)
                .axt(.toggle, "show_more")
            if showMore {
                Group {
                    Toggle("2", isOn: $value2)
                    Toggle("3", isOn: $value3)
                    Toggle("4", isOn: $value4)
                }
                .axt("more_content")
            }
        }
    }
}
