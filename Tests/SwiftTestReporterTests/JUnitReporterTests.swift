@testable import SwiftTestReporter
import XCTest

extension String {
    func replacingTabsWithSpaces() -> String {
        return replacingOccurrences(of: "\t", with: "    ")
    }
}

class JUnitReporterTests: XCTestCase {
    private func makeTestCaseStub(name: String = "Stub Test") -> TestSuite {
        class StubTestSuite: XCTestSuite {}
        return TestSuite(StubTestSuite(name: name))
    }

    func testReporterShouldReturnXMLForEmptySuite() {
        let testSuite = makeTestCaseStub()
        let expected = """
        <?xml version="1.0" encoding="UTF-8"?>
        <testsuites>
            <testsuite tests="0" failures="0" disabled="0" errors="0" time="0.0" name="Stub Test">

            </testsuite>
        </testsuites>
        """
        JUnitReporter().report(for: [testSuite]) { content in
            XCTAssertEqual(content.replacingTabsWithSpaces(), expected.replacingTabsWithSpaces())
        }
    }

    // TODO: fix test on Mac
    func testReporterShouldReturnXMLForFailedTest() {
        let testSuite = makeTestCaseStub()
        let expected = """
        <?xml version="1.0" encoding="UTF-8"?>
        <testsuites>
            <testsuite tests="1" failures="1" disabled="0" errors="0" time="0.0" name="Stub Test">
                <testcase classname="SwiftTestReporterTests.JUnitReporterTests" name="testReporterShouldReturnXMLForFailedTest" time="0.0">
                    <failure message="test failed"></failure>
                </testcase>
            </testsuite>
        </testsuites>
        """
        testSuite.testCases["test1"] = Test(self).failure(Failure(message: "test failed"))
        JUnitReporter().report(for: [testSuite]) { content in
            XCTAssertEqual(content.replacingTabsWithSpaces(), expected.replacingTabsWithSpaces())
        }
    }

    static var allTests = [
        ("testReporterShouldReturnXMLForEmptySuite", testReporterShouldReturnXMLForEmptySuite),
        ("testReporterShouldReturnXMLForFailedTest", testReporterShouldReturnXMLForFailedTest)
    ]
}
