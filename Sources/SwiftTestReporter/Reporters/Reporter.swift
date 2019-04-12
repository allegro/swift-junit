typealias ReporterHandler = ([TestSuite]) -> String
public typealias WriteHandler = (String) -> Void
public typealias TestSuites = [TestSuite]

/// Protocol for all reporters.
public protocol Reporter {
    /// Descriptive name.
    var name: String { get }

    /// Generates report for test suites and saves report by handler.
    func report(for suites: TestSuites, handler: WriteHandler)
}
