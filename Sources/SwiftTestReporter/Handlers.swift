import Foundation

/// Simplest handler - prints to stdout.
func stdoutHandler(_ content: String) {
    print(content)
}

/// Writes content to file.
func fileHandler(_ content: String) {
    let fileName = ProcessInfo.processInfo.environment["SWIFT_JUNIT_RESULT_PATH"] ?? "tests.xml"
    do {
        try content.write(toFile: fileName, atomically: true, encoding: .utf8)
        print("Test report (\(fileName)) has been saved successfully.")
    } catch {
        print("Something went wrong during save report.")
    }
}
