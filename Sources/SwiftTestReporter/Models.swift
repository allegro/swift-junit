import Foundation
import XCTest

typealias TestCaseKey = String

// Wrapper around XCTestSuite from XCTest
public class TestSuite {
    let name: String
    var duration: TimeInterval
    let timestamp: String
    var testCases: [TestCaseKey: Test] = [:]
    var testCasesWithFailure: [Test] {
            return Array(testCases.filter { _, value in value.failure != nil }.values)
        }

    var testCasesWithError: [Test] {
            return Array(testCases.filter { _, value in value.error != nil }.values)
        }

    func markTest(_ test: XCTest, failure: Failure) {
        let key = TestSuite.getTestCaseKey(for: test)
        if let testCase = testCases[key] {
            testCases[key] = testCase.failure(failure)
        }
    }

    func markTest(_ test: XCTest, error: Error) {
        let key = TestSuite.getTestCaseKey(for: test)
        if let testCase = testCases[key] {
            testCases[key] = testCase.error(error)
        }
    }

    func updateTestDuration(for test: XCTest, _ duration: TimeInterval) {
        let key = TestSuite.getTestCaseKey(for: test)
        if let testCase = testCases[key] {
            testCases[key] = testCase.duration(duration)
        }
    }

    static func getTestCaseKey(for testCase: XCTest) -> TestCaseKey {
        return "\(testCase)" + testCase.name
    }

    init(_ testSuite: XCTestSuite) {
        name = testSuite.name
        duration = testSuite.testRun?.totalDuration ?? 0
        timestamp = testSuite.testRun?.startDate?.timeIntervalSince1970.description ?? "0"
        testCases = Dictionary(uniqueKeysWithValues: testSuite.tests.map { testCase in (TestSuite.getTestCaseKey(for: testCase), Test(testCase)) })
    }
}

// Wrapper around XCTest from XCTest
struct Test {
    let test: XCTest
    var className: String {
            return "\(test)"
        }

    var name: String {
            return test.name.components(separatedBy: ".").last ?? "unknown name"
        }

    let duration: TimeInterval
    let failure: Failure?
    let error: Error?

    init(_ test: XCTest, failure: Failure? = nil, error: Error? = nil, duration: TimeInterval? = nil) {
        self.test = test
        self.failure = failure
        self.error = error
        if let duration = duration {
            self.duration = duration
        } else {
            self.duration = test.testRun?.testDuration ?? 0
        }
    }
}

// Make struct immutable
extension Test {
    func failure(_ failure: Failure) -> Test {
        return Test(test, failure: failure, error: error, duration: duration)
    }

    func error(_ error: Error) -> Test {
        return Test(test, failure: failure, error: error, duration: duration)
    }

    func duration(_ duration: TimeInterval) -> Test {
        return Test(test, failure: failure, error: error, duration: duration)
    }
}

struct Failure: Encodable {
    let message: String
}

struct Error: Encodable {
    let message: String
}
