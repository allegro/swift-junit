protocol XMLJUnitFormat {
    func getXMLElement() -> JUnitElement
}

extension TestSuite: XMLJUnitFormat {
    func getXMLElement() -> JUnitElement {
        let testCases = self.testCases.map { _, value in value.getXMLElement() }
        return JUnitElement.testSuite(
            testsCount: self.testCases.count,
            failuresCount: testCasesWithFailure.count,
            disabledCount: 0,
            errorsCountInt: testCasesWithError.count,
            skippedCount: skippedTestCount,
            duration: duration,
            name: name,
            tests: testCases
        )
    }
}

extension Test: XMLJUnitFormat {
    func getXMLElement() -> JUnitElement {
        return .testCase(
            className: className,
            name: name,
            duration: duration,
            failure: failure?.getXMLElement(),
            error: error?.getXMLElement(),
            skipped: skipped
        )
    }
}

extension Failure: XMLJUnitFormat {
    func getXMLElement() -> JUnitElement {
        return JUnitElement.failure(message: message)
    }
}

extension Error: XMLJUnitFormat {
    func getXMLElement() -> JUnitElement {
        return JUnitElement.error(message: message)
    }
}
