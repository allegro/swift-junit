import XCTest

private func lastChunk(_ phrase: String, separator: Character = ".") -> String {
    return phrase.split(separator: separator).last?.description ?? phrase
}

extension XCTest {
    /// Simple helper that returns class name for XCTest.
    /// There are some difference between original XCTest on different platforms and XCTest in open source and this
    /// helper solves one of the problems - missing property (className).
    /// - Returns: A normalized name for XCTest's instance
    var customClassName : String {
        let fullClassName = "\(type(of: self))"
        return fullClassName
    }
}
