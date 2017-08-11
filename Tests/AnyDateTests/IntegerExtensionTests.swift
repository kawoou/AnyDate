import XCTest
import Foundation
import AnyDate

class IntegerExtensionTests: XCTestCase {
    
    func testAddOperator() {
        let date = LocalDateTime(
            year: 1000,
            month: 1,
            day: 7,
            hour: 11,
            minute: 51,
            second: 18,
            nanoOfSecond: 1573
        )

        let period1 = 1.year + 1.week + 2.hour
        let newDate1 = date + period1

        XCTAssertEqual(newDate1.year, 1001)
        XCTAssertEqual(newDate1.month, 1)
        XCTAssertEqual(newDate1.day, 14)
        XCTAssertEqual(newDate1.hour, 13)
        XCTAssertEqual(newDate1.minute, 51)
        XCTAssertEqual(newDate1.second, 18)
        XCTAssertEqual(newDate1.nano, 1573)

        let period2 = 1.month + 2.day + 3.minute + 4.second + 152.nanosecond
        let newDate2 = newDate1 + period2

        XCTAssertEqual(newDate2.year, 1001)
        XCTAssertEqual(newDate2.month, 2)
        XCTAssertEqual(newDate2.day, 16)
        XCTAssertEqual(newDate2.hour, 13)
        XCTAssertEqual(newDate2.minute, 54)
        XCTAssertEqual(newDate2.second, 22)
        XCTAssertEqual(newDate2.nano, 1725)
    }

    func testSubtractOperator() {
        let date = LocalDateTime(
            year: 1000,
            month: 2,
            day: 14,
            hour: 11,
            minute: 51,
            second: 18,
            nanoOfSecond: 1573
        )

        let period1 = 1.year + 1.week + 2.hour
        let newDate1 = date - period1

        XCTAssertEqual(newDate1.year, 999)
        XCTAssertEqual(newDate1.month, 2)
        XCTAssertEqual(newDate1.day, 7)
        XCTAssertEqual(newDate1.hour, 9)
        XCTAssertEqual(newDate1.minute, 51)
        XCTAssertEqual(newDate1.second, 18)
        XCTAssertEqual(newDate1.nano, 1573)

        let period2 = 1.month + 2.day + 3.minute + 4.second + 152.nanosecond
        let newDate2 = newDate1 - period2

        XCTAssertEqual(newDate2.year, 999)
        XCTAssertEqual(newDate2.month, 1)
        XCTAssertEqual(newDate2.day, 5)
        XCTAssertEqual(newDate2.hour, 9)
        XCTAssertEqual(newDate2.minute, 48)
        XCTAssertEqual(newDate2.second, 14)
        XCTAssertEqual(newDate2.nano, 1421)
    }

}