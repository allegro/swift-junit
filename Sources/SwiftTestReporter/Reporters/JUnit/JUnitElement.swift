import Foundation
import HTMLString

/// Describes all elements needed to build valid XML.
indirect enum JUnitElement: CustomStringConvertible {
    case preamble
    case testSuitesStart
    case testSuitesEnd
    case testSuite(testsCount: Int, failuresCount: Int, disabledCount: Int, errorsCountInt: Int, skippedCount: Int, duration: TimeInterval, name: String, tests: [JUnitElement])
    case testCase(className: String, name: String, duration: TimeInterval, failure: JUnitElement?, error: JUnitElement?, skipped: Bool)
    case failure(message: String)
    case error(message: String)

    var description: String {
        switch self {
        case .preamble:
            return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"

        case .testSuitesStart:
            return "<testsuites>"

        case .testSuitesEnd:
            return "</testsuites>"

        case .testSuite(let testsCount, let failuresCount, let disabledCount, let errorsCount, let skippedCount, let time, let name, let tests):
            let testsElement = tests.map { $0.description }.joined(separator: "\n")
            return """
            \t<testsuite tests=\"\(testsCount)\" failures=\"\(failuresCount)\" disabled=\"\(disabledCount)\" errors=\"\(errorsCount)\" skipped=\"\(skippedCount)\" time=\"\(time)\" name=\"\(name)\">
            \(testsElement)
            \t</testsuite>
            """

        case .testCase(let className, let name, let duration, let failure, let error, let skipped):
            var testCaseElement = "\t\t<testcase classname=\"\(className)\" name=\"\(name)\" time=\"\(duration)\">"
            if let failure = failure {
                testCaseElement += failure.description
            }
            if let error = error {
                testCaseElement += error.description
            }
            if skipped {
                testCaseElement += "<skipped/>"
            }
            testCaseElement += "</testcase>"
            return testCaseElement

        case .failure(let message):
            return "\n\t\t\t<failure message=\"\(message.addingASCIIEntities)\"></failure>\n\t\t"

        case .error(let message):
            return "\n\t\t\t<error message=\"\(message.addingASCIIEntities)\"></error>\n\t\t"
        }
    }
}
