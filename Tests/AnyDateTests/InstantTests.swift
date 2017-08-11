import XCTest
import Foundation
import AnyDate

class InstantTests: XCTestCase {
    
    func testComparable() {
        let min = Instant.min
        let max = Instant.max

        let oldDate = Instant(epochSecond: 100_000, nano: 999_999_000)
        let newDate = Instant(epochSecond: 100_000, nano: 999_999_001)
        let equalDate = Instant(epochSecond: 100_000, nano: 999_999_000)

        XCTAssertLessThan(min, oldDate)
        XCTAssertGreaterThan(max, newDate)
        XCTAssertLessThanOrEqual(oldDate, equalDate)
        XCTAssertGreaterThanOrEqual(oldDate, equalDate)
        XCTAssertEqual(oldDate, equalDate)
        XCTAssertLessThan(oldDate, newDate)
    }
    func testEpoch() {
        let instant = Instant.epoch
        XCTAssertEqual(instant.second, 0)
        XCTAssertEqual(instant.nano, 0)
    }
    func testMin() {
        let min = Instant.min
        XCTAssertEqual(min.second, -31_557_014_167_219_200)
        XCTAssertEqual(min.nano, 0)
    }
    func testMax() {
        let max = Instant.max
        XCTAssertEqual(max.second, 31_556_889_864_403_199)
        XCTAssertEqual(max.nano, 999_999_999)
    }
    func testEpochMilli() {
        let instant1 = Instant(epochSecond: 100_000, nano: 999_999_999)
        XCTAssertEqual(instant1.epochMilli, 100_000_999)

        let instant2 = Instant(epochMilli: 100_000_999)
        XCTAssertEqual(instant2.second, 100_000)
        XCTAssertEqual(instant2.nano, 999_000_000)
    }
    func testParse() {
        let instant = Instant.parse("1970-1-1T0:1:5.123Z")!
        XCTAssertEqual(instant.second, 65)
        XCTAssertGreaterThan(123_500_000, instant.nano)
        XCTAssertLessThanOrEqual(122_500_000, instant.nano)
    }
    func testToZone() {
        let instant = Instant(epochSecond: 65, nano: 123_000_000)
        let zone = instant.toZone()

        XCTAssertEqual(zone.year, 1970)
        XCTAssertEqual(zone.month, 1)
        XCTAssertEqual(zone.day, 1)
        XCTAssertEqual(zone.hour, 0)
        XCTAssertEqual(zone.minute, 1)
        XCTAssertEqual(zone.second, 5)
        XCTAssertEqual(zone.nano, 123_000_000)
    }
    func testPlus() {
        let instant = Instant(epochSecond: 100_000, nano: 999_000_000)

        let compare1 = Instant(epochSecond: 100_001, nano: 999_000_000)
        let compare2 = Instant(epochSecond: 100_000, nano: 999_000_001)
        let compare3 = Instant(epochSecond: 100_001, nano: 000_000_000)

        XCTAssertEqual(instant.plus(second: 1), compare1)
        XCTAssertEqual(instant.plus(nano: 1), compare2)
        XCTAssertEqual(instant.plus(milli: 1), compare3)
    }
    func testMinus() {
        let instant = Instant(epochSecond: 100_000, nano: 999_000_000)

        let compare1 = Instant(epochSecond: 99_999, nano: 999_000_000)
        let compare2 = Instant(epochSecond: 100_000, nano: 998_999_999)
        let compare3 = Instant(epochSecond: 100_000, nano: 998_000_000)

        XCTAssertEqual(instant.minus(second: 1), compare1)
        XCTAssertEqual(instant.minus(nano: 1), compare2)
        XCTAssertEqual(instant.minus(milli: 1), compare3)
    }
    func testUntil() {
        let instant = Instant(epochSecond: 100_000, nano: 999_000_000)
        let zero = Instant(epochSecond: 0, nano: 0)
        
        XCTAssertEqual(zero.until(endInstant: instant, component: .nanosecond), 100_000_999_000_000)
        XCTAssertEqual(zero.until(endInstant: instant, component: .second), 100_000)
        XCTAssertEqual(zero.until(endInstant: instant, component: .minute), 1666)
        XCTAssertEqual(zero.until(endInstant: instant, component: .hour), 27)
        XCTAssertEqual(zero.until(endInstant: instant, component: .day), 1)
    }
    func testWith() {
        let instant = Instant(epochSecond: 100_000, nano: 999_000_000)

        let compare1 = Instant(epochSecond: 500, nano: 999_000_000)
        let compare2 = Instant(epochSecond: 100_000, nano: 500)

        XCTAssertEqual(instant.with(component: .second, newValue: 500), compare1)
        XCTAssertEqual(instant.with(component: .nanosecond, newValue: 500), compare2)
    }

}