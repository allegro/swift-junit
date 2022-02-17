@testable import SwiftTestReporter
import XCTest

extension String {
    func replacingTabsWithSpaces() -> String {
        return replacingOccurrences(of: "\t", with: "    ")
    }
}

class JUnitReporterTests: XCTestCase {
    private func makeTestCaseStub(name: String = "Stub Test", testCases: [TestCaseKey: Test] = [:]) -> TestSuite {
        return TestSuite(name: name, testCases: testCases)
    }

    func testReporterShouldReturnXMLForEmptySuite() {
        let testSuite = makeTestCaseStub()
        let expected = """
        <?xml version="1.0" encoding="UTF-8"?>
        <testsuites>
            <testsuite tests="0" failures="0" disabled="0" errors="0" skipped="0" time="0.0" name="Stub Test">

            </testsuite>
        </testsuites>
        """
        JUnitReporter().report(for: [testSuite]) { content in
            XCTAssertEqual(content.replacingTabsWithSpaces(), expected.replacingTabsWithSpaces())
        }
    }

    func testReporterShouldReturnXMLForFailedTest() {
        #if os(Linux)
        let className = "SwiftTestReporterTests.JUnitReporterTests"
        let testName = "testReporterShouldReturnXMLForFailedTest"
        #else
        let className = "-[JUnitReporterTests testReporterShouldReturnXMLForFailedTest]"
        let testName = "-[JUnitReporterTests testReporterShouldReturnXMLForFailedTest]"
        #endif
        let testCase = Test(self).setFailure(Failure(message: "test failed"))
        let testSuite = makeTestCaseStub(name: "TestFoo", testCases: ["test": testCase])
        let expected = """
        <?xml version="1.0" encoding="UTF-8"?>
        <testsuites>
            <testsuite tests="1" failures="1" disabled="0" errors="0" skipped="0" time="0.0" name="TestFoo">
                <testcase classname="\(className)" name="\(testName)" time="0.0">
                    <failure message="test failed"></failure>
                </testcase>
            </testsuite>
        </testsuites>
        """
        JUnitReporter().report(for: [testSuite]) { content in
            XCTAssertEqual(content.replacingTabsWithSpaces(), expected.replacingTabsWithSpaces())
        }
    }

  func testReporterShouldReturnXMLForSkippedTest() {
      #if os(Linux)
      let className = "SwiftTestReporterTests.JUnitReporterTests"
      let testName = "testReporterShouldReturnXMLForSkippedTest"
      #else
      let className = "-[JUnitReporterTests testReporterShouldReturnXMLForSkippedTest]"
      let testName = "-[JUnitReporterTests testReporterShouldReturnXMLForSkippedTest]"
      #endif
      let testCase = Test(self).setSkipped()
      let testSuite = makeTestCaseStub(name: "TestFoo", testCases: ["test": testCase])
      let expected = """
      <?xml version="1.0" encoding="UTF-8"?>
      <testsuites>
          <testsuite tests="1" failures="0" disabled="0" errors="0" skipped="1" time="0.0" name="TestFoo">
              <testcase classname="\(className)" name="\(testName)" time="0.0"><skipped/></testcase>
          </testsuite>
      </testsuites>
      """
      JUnitReporter().report(for: [testSuite]) { content in
          XCTAssertEqual(content.replacingTabsWithSpaces(), expected.replacingTabsWithSpaces())
      }
  }

    
    func testProperEscapingOfErrorMessages() {
        #if os(Linux)
        let className = "SwiftTestReporterTests.JUnitReporterTests"
        let testName = "testProperEscapingOfErrorMessages"
        #else
        let className = "-[JUnitReporterTests testProperEscapingOfErrorMessages]"
        let testName = "-[JUnitReporterTests testProperEscapingOfErrorMessages]"
        #endif
        let testCase = Test(self).setFailure(Failure(message: "\"test\" \"failed\""))
        let testSuite = makeTestCaseStub(name: "TestFoo", testCases: ["test": testCase])
        let expected = """
        <?xml version="1.0" encoding="UTF-8"?>
        <testsuites>
            <testsuite tests="1" failures="1" disabled="0" errors="0" skipped="0" time="0.0" name="TestFoo">
                <testcase classname="\(className)" name="\(testName)" time="0.0">
                    <failure message="&#34;test&#34; &#34;failed&#34;"></failure>
                </testcase>
            </testsuite>
        </testsuites>
        """
        JUnitReporter().report(for: [testSuite]) { content in
            XCTAssertEqual(content.replacingTabsWithSpaces(), expected.replacingTabsWithSpaces())
        }
    }

    static var allTests = [
        ("testReporterShouldReturnXMLForEmptySuite", testReporterShouldReturnXMLForEmptySuite),
        ("testReporterShouldReturnXMLForFailedTest", testReporterShouldReturnXMLForFailedTest),
        ("testProperEscapingOfErrorMessages", testProperEscapingOfErrorMessages),
    ]
}
