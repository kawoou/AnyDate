import XCTest
import Foundation
import AnyDate

class PeriodTests: XCTestCase {

    func testPropertySetter() {
        var zero = Period()
        zero.year = 100
        zero.month = 2
        zero.day = -12
        zero.hour = -12
        zero.minute = 2
        zero.second = -12
        zero.nano = -125_221
        
        XCTAssertEqual(zero.year, 100)
        XCTAssertEqual(zero.month, 1)
        XCTAssertEqual(zero.day, 15)
        XCTAssertEqual(zero.hour, 12)
        XCTAssertEqual(zero.minute, 1)
        XCTAssertEqual(zero.second, 47)
        XCTAssertEqual(zero.nano, 999_874_779)
    }
    func testNormalize() {
        let period = Period(year: 0, month: 11, day: 30, hour: 23, minute: 59, second: 59, nano: 1000_000_000)
        XCTAssertEqual(period.year, 1)
        XCTAssertEqual(period.month, 0)
        XCTAssertEqual(period.day, 0)
        XCTAssertEqual(period.hour, 0)
        XCTAssertEqual(period.minute, 0)
        XCTAssertEqual(period.second, 0)
        XCTAssertEqual(period.nano, 0)
    }
    func testAddOperator() {
        let localDate = LocalDateTime(year: 1000, month: 1, day: 1, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let zonedDate = ZonedDateTime(year: 1000, month: 1, day: 1, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let addPeriod = Period(year: 0, month: 1, day: 3, hour: 0, minute: 8, second: 0, nano: 0)

        let newLocalDate = localDate + addPeriod
        let newZonedDate = zonedDate + addPeriod

        XCTAssertEqual(newLocalDate.year, 1000)
        XCTAssertEqual(newLocalDate.month, 2)
        XCTAssertEqual(newLocalDate.day, 4)
        XCTAssertEqual(newLocalDate.hour, 11)
        XCTAssertEqual(newLocalDate.minute, 59)
        XCTAssertEqual(newLocalDate.second, 18)
        XCTAssertEqual(newLocalDate.nano, 1573)

        XCTAssertEqual(newZonedDate.year, 1000)
        XCTAssertEqual(newZonedDate.month, 2)
        XCTAssertEqual(newZonedDate.day, 4)
        XCTAssertEqual(newZonedDate.hour, 11)
        XCTAssertEqual(newZonedDate.minute, 59)
        XCTAssertEqual(newZonedDate.second, 18)
        XCTAssertEqual(newZonedDate.nano, 1573)
    }

    func testSubtractOperator() {
        let localDate = LocalDateTime(year: 1000, month: 1, day: 7, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let zonedDate = ZonedDateTime(year: 1000, month: 1, day: 7, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let addPeriod = Period(year: 0, month: 1, day: 3, hour: 0, minute: 8, second: 0, nano: 0)

        let newLocalDate = localDate - addPeriod
        let newZonedDate = zonedDate - addPeriod

        XCTAssertEqual(newLocalDate.year, 999)
        XCTAssertEqual(newLocalDate.month, 12)
        XCTAssertEqual(newLocalDate.day, 4)
        XCTAssertEqual(newLocalDate.hour, 11)
        XCTAssertEqual(newLocalDate.minute, 43)
        XCTAssertEqual(newLocalDate.second, 18)
        XCTAssertEqual(newLocalDate.nano, 1573)

        XCTAssertEqual(newZonedDate.year, 999)
        XCTAssertEqual(newZonedDate.month, 12)
        XCTAssertEqual(newZonedDate.day, 4)
        XCTAssertEqual(newZonedDate.hour, 11)
        XCTAssertEqual(newZonedDate.minute, 43)
        XCTAssertEqual(newZonedDate.second, 18)
        XCTAssertEqual(newZonedDate.nano, 1573)
    }

}
