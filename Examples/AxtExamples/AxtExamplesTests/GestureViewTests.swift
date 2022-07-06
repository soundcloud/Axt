import XCTest
@testable import AxtExamples
import Axt
import SwiftUI

@MainActor
class GestureViewTests: XCTestCase {

//    func testWatch() async {
//        let test = await AxtTest.host(GestureView())
//
//        await test.watchHierarchy()
//    }

    func testKnob() async throws {
        let test = await AxtTest.host(GestureView())
        let knob = try XCTUnwrap(test.find(id: "knob"))
        let dragValue = try XCTUnwrap(test.find(id: "drag"))

        let drag: CGFloat = 500.0
        dragValue.setValue(drag)
        await AxtTest.yield()

        XCTAssertEqual(knob.value as? String, "circle")
    }

}
