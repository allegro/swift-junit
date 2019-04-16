#if os(Linux)

@testable import SwiftTestReporter
@testable import SwiftTestReporterTests
import XCTest

_ = TestObserver()

XCTMain([
    testCase(JUnitReporterTests.allTests),
    testCase(UtilsTests.allTests),
    testCase(HandlersTests.allTests)
])

#endif
