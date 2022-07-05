import XCTest
@testable import AxtExamples
import Axt

@MainActor
class TogglesViewTests: XCTestCase {

//    func testWatch() async {
//        let test = await AxtTest.host(TogglesView())
//
//        await test.watchHierarchy()
//    }

    func testShowMore() async throws {
        let test = await AxtTest.host(TogglesView())
        let moreToggle = try XCTUnwrap(test.find(id: "show_more"))

        moreToggle.performAction()
        await AxtTest.yield()

        XCTAssertNotNil(test.find(id: "more_content"))
    }

}
