import XCTest
@testable import AxtExamples
import Axt
import SwiftUI

@MainActor
class ConfirmationAlertModifierTests: XCTestCase {

    func testWatch() async {
        struct MyView: View {
            @State var alertPresented = false
            var body: some View {
                Button("Present alert") { alertPresented.toggle() }
                    .modifier(ConfirmationAlertModifier(isPresented: $alertPresented, message: "Are you sure?", action1: { print("yes") }, action2: { print("no") }))
            }
        }
        let test = await AxtTest.host(MyView())

        await test.watchHierarchy()
    }

}
