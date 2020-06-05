@testable import SwiftTestReporter
import XCTest

class UtilsTests: XCTestCase {
    func testShouldReturnProperlyClassName() {
        let xcTest: XCTest = self
        XCTAssertEqual(xcTest.customClassName, "UtilsTests")
    }

    func testShouldReturnProperlyClassNameForNestedClass() {
        class FooTestCase: XCTest {}
        let xcTest: XCTest = FooTestCase()
        XCTAssertEqual(xcTest.customClassName, "FooTestCase")
    }

    static var allTests = [
        ("testShouldReturnProperlyClassName", testShouldReturnProperlyClassName)
    ]
}
