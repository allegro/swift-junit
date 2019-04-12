
class JUnitReporter: Reporter {
    let name = "JUnit format"

    private func render(_ suites: TestSuites) -> String {
        let suitesResult = suites.map { "\($0.getXMLElement())" }.joined(separator: "\n")
        return """
        \(JUnitElement.preamble)
        \(JUnitElement.testSuitesStart)
        \(suitesResult)
        \(JUnitElement.testSuitesEnd)
        """
    }

    func report(for suites: TestSuites, handler: WriteHandler) {
        let xmlReport = render(suites)
        handler(xmlReport)
    }
}
