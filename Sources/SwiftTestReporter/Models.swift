import Foundation
import XCTest

public typealias TestCaseKey = String

// Wrapper around XCTestSuite from XCTest
public final class TestSuite {
    public let name: String
    public fileprivate(set) var testCases: [TestCaseKey: Test] = [:]
    var duration: TimeInterval {
        return testCases.values.reduce(0) { result, next in
            return result + next.duration
        }
    }

    init(name: String, testCases: [TestCaseKey: Test]) {
        self.name = name
        self.testCases = testCases
    }

    convenience init(_ testSuite: XCTestSuite) {
        let testCases = Dictionary(uniqueKeysWithValues: testSuite.tests.map { testCase in (TestSuite.getTestCaseKey(for: testCase), Test(testCase)) })
        self.init(name: testSuite.name, testCases: testCases)
    }

    // MARK: - Getters

    var testCasesWithFailure: [Test] {
        return Array(testCases.filter { _, value in value.failure != nil }.values)
    }

    var testCasesWithError: [Test] {
        return Array(testCases.filter { _, value in value.error != nil }.values)
    }

    // MARK: - Helpers

    static func getTestCaseKey(for testCase: XCTest) -> TestCaseKey {
        return "\(testCase)" + testCase.name
    }

    func markTest(_ test: XCTest, failure: Failure) {
        let key = TestSuite.getTestCaseKey(for: test)
        if let testCase = testCases[key] {
            testCases[key] = testCase.setFailure(failure)
        }
    }

    func markTest(_ test: XCTest, error: Error) {
        let key = TestSuite.getTestCaseKey(for: test)
        if let testCase = testCases[key] {
            testCases[key] = testCase.setError(error)
        }
    }

    func updateTestDuration(for test: XCTest, _ duration: TimeInterval) {
        let key = TestSuite.getTestCaseKey(for: test)
        if let testCase = testCases[key] {
            testCases[key] = testCase.setDuration(duration)
        }
    }
}

// Wrapper around XCTest from XCTest
public struct Test {
    private let test: XCTest
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
    func setFailure(_ failure: Failure) -> Test {
        return Test(test, failure: failure, error: error, duration: duration)
    }

    func setError(_ error: Error) -> Test {
        return Test(test, failure: failure, error: error, duration: duration)
    }

    func setDuration(_ duration: TimeInterval) -> Test {
        return Test(test, failure: failure, error: error, duration: duration)
    }
}

struct Failure: Encodable {
    let message: String
}

struct Error: Encodable {
    let message: String
}
