import Foundation
import XCTest

public final class TestObserver: NSObject {
    var testSuites: TestSuites = []
    var currentTestSuite: TestSuite?
    var failed: [Test] = []
    var errored: [Test] = []
    var reporter: Reporter = JUnitReporter()
    var reportHandler: WriteHandler = fileHandler

    public override init() {
        /// Register to XCTestObservationCenter is placed here because if you want generate report directly
        /// from XCode's test runner you must override 'Principle class' property.
        super.init()
        XCTestObservationCenter.shared.addTestObserver(self)
    }
}

extension TestObserver: XCTestObservation {
    func isTestCaseSuite(_ testSuite: XCTestSuite) -> Bool {
        /// - Note: XCTestCaseSuite is internal class
        /// XCTestCaseSuite is a test suite which is associated with a particular test case class.
        /// XCTest creates additional XCTestSuite:
        ///  - "All Test" which contains all test suites
        ///  - test suite for each module in tests (e.g. SwiftTestReporterTests)
        let className = testSuite.customClassName
        return className == "XCTestCaseSuite"
    }

    // MARK: - Test case

    public func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile _: String?, atLine _: Int) {
        if let currentTestSuite = currentTestSuite {
            if testCase.testRun!.unexpectedExceptionCount > 0 {
                currentTestSuite.markTest(testCase, error: Error(message: description))
            } else {
                currentTestSuite.markTest(testCase, failure: Failure(message: description))
            }
        }
    }

    public func testCaseDidFinish(_ testCase: XCTestCase) {
        let testRun = testCase.testRun!
        if let currentTestSuite = currentTestSuite {
            if testRun.hasBeenSkipped {
                currentTestSuite.markTestSkipped(testCase)
            }
            currentTestSuite.updateTestDuration(for: testCase, testRun.totalDuration)
        }
    }

    // MARK: - Test suite

    public func testSuiteWillStart(_ testSuite: XCTestSuite) {
        if isTestCaseSuite(testSuite) {
            currentTestSuite = TestSuite(testSuite)
        }
    }

    // MARK: - Bundle

    public func testSuiteDidFinish(_ testSuite: XCTestSuite) {
        if isTestCaseSuite(testSuite) {
            if let currentTestSuite = currentTestSuite {
                testSuites.append(currentTestSuite)
            }
        }
    }

    public func testBundleDidFinish(_: Bundle) {
        reporter.report(for: testSuites, handler: reportHandler)
    }
}
