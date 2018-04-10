@testable import AnyDateTests
import XCTest

XCTMain([
    testCase(ClockTests.allTests),
    testCase(InstantTests.allTests),
    testCase(IntegerExtensionTests.allTests),
    testCase(LocalDateTests.allTests),
    testCase(LocalDateTimeTests.allTests),
    testCase(LocalTimeTests.allTests),
    testCase(PeriodTests.allTests),
    testCase(ZonedDateTimeTests.allTests)
])
