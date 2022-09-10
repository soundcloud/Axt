import XCTest
@testable import AxtExamples
import Axt
import SwiftUI

@MainActor
class MoreButtonTests: XCTestCase {

    func test_sheet() async throws {
        let test = await AxtTest.host(LessMenu())
        let button = try XCTUnwrap(test.find(id: "more_button"))

        await button.performAction()

        let sheet = try XCTUnwrap(AxtTest.sheets.first?.value)
        XCTAssertNotNil(sheet.find(id: "more_text"))
    }
}
