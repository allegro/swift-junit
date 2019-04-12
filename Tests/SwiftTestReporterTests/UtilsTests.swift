@testable import SwiftTestReporter
import XCTest

class UtilsTests: XCTestCase {
    func testShouldReturnProperlyClassName() {
        class FooTestCase: XCTest {}
        XCTAssertEqual(getXCTestClassName(self), "UtilsTests")
    }

    static var allTests = [
        ("testShouldReturnProperlyClassName", testShouldReturnProperlyClassName)
    ]
}
