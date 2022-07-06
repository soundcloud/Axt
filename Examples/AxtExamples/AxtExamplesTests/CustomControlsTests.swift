import XCTest
@testable import AxtExamples
import Axt

@MainActor
class CustomControlsTests: XCTestCase {

    func testWatch() async {
        let test = await AxtTest.host(CustomControls())

        await test.watchHierarchy()
    }

}
