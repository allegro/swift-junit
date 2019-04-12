import XCTest

private func lastChunk(_ phrase: String, separator: Character = ".") -> String {
    return phrase.split(separator: separator).last?.description ?? phrase
}

/// Simple helper that returns class name for XCTest.
/// There are some difference beween original XCTest and XCTest in open source and this
/// helper solves one of the problems - missing property (className).
/// - Parameter obj: XCTest's instance
/// - Returns: A normalized name for XCTest's instance
func getXCTestClassName(_ obj: XCTest) -> String {
    #if os(Linux)
    let className = "\(obj.self)"
    #else
    let className = obj.className
    #endif
    return lastChunk(className)
}
