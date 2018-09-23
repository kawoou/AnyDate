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
    func testComparable() {
        let min = Period()
        let max = Period(year: 1000)
        
        let oldPeriod = Period(month: 2)
        let newPeriod1 = Period(year: 1, month: 2)
        let newPeriod2 = Period(month: 3)
        let newPeriod3 = Period(month: 2, day: 1)
        let newPeriod4 = Period(month: 2, hour: 1)
        let newPeriod5 = Period(month: 2, minute: 1)
        let newPeriod6 = Period(month: 2, second: 1)
        let newPeriod7 = Period(month: 2, nano: 1)
        let equalPeriod = Period(year: 0, month: 2)
        
        XCTAssertLessThan(min, oldPeriod)
        XCTAssertGreaterThan(max, newPeriod1)
        XCTAssertLessThanOrEqual(oldPeriod, equalPeriod)
        XCTAssertGreaterThanOrEqual(oldPeriod, equalPeriod)
        XCTAssertGreaterThan(newPeriod1, oldPeriod)
        XCTAssertGreaterThan(newPeriod2, oldPeriod)
        XCTAssertGreaterThan(newPeriod3, oldPeriod)
        XCTAssertGreaterThan(newPeriod4, oldPeriod)
        XCTAssertGreaterThan(newPeriod5, oldPeriod)
        XCTAssertGreaterThan(newPeriod6, oldPeriod)
        XCTAssertGreaterThan(newPeriod7, oldPeriod)
        XCTAssertLessThan(oldPeriod, newPeriod1)
        XCTAssertLessThan(oldPeriod, newPeriod2)
        XCTAssertLessThan(oldPeriod, newPeriod3)
        XCTAssertLessThan(oldPeriod, newPeriod4)
        XCTAssertLessThan(oldPeriod, newPeriod5)
        XCTAssertLessThan(oldPeriod, newPeriod6)
        XCTAssertLessThan(oldPeriod, newPeriod7)
        XCTAssertNotEqual(oldPeriod, newPeriod1)
        XCTAssertNotEqual(oldPeriod, newPeriod2)
        XCTAssertNotEqual(oldPeriod, newPeriod3)
        XCTAssertNotEqual(oldPeriod, newPeriod4)
        XCTAssertNotEqual(oldPeriod, newPeriod5)
        XCTAssertNotEqual(oldPeriod, newPeriod6)
        XCTAssertNotEqual(oldPeriod, newPeriod7)
        XCTAssertEqual(oldPeriod, equalPeriod)
        XCTAssertLessThan(oldPeriod, newPeriod1)

        /// #15 TestCode
        let test1 = Period(year: 1500, month: 6, day: 15, hour: 12, minute: 30, second: 30, nano: 500_000_000)
        let test2 = Period(year: 1499, month: 6, day: 15, hour: 12, minute: 30, second: 30, nano: 500_000_001)
        let test3 = Period(year: 1499, month: 6, day: 15, hour: 12, minute: 30, second: 31, nano: 500_000_000)
        let test4 = Period(year: 1499, month: 6, day: 15, hour: 12, minute: 31, second: 30, nano: 500_000_000)
        let test5 = Period(year: 1499, month: 6, day: 15, hour: 13, minute: 30, second: 30, nano: 500_000_000)
        let test6 = Period(year: 1499, month: 6, day: 16, hour: 12, minute: 30, second: 30, nano: 500_000_000)
        let test7 = Period(year: 1499, month: 7, day: 15, hour: 12, minute: 30, second: 30, nano: 500_000_000)
        XCTAssertGreaterThan(test1, test2)
        XCTAssertGreaterThan(test1, test3)
        XCTAssertGreaterThan(test1, test4)
        XCTAssertGreaterThan(test1, test5)
        XCTAssertGreaterThan(test1, test6)
        XCTAssertGreaterThan(test1, test7)

        let test8 = Period(year: 1501, month: 6, day: 15, hour: 12, minute: 30, second: 30, nano: 499_999_999)
        let test9 = Period(year: 1501, month: 6, day: 15, hour: 12, minute: 30, second: 29, nano: 500_000_000)
        let test10 = Period(year: 1501, month: 6, day: 15, hour: 12, minute: 29, second: 30, nano: 500_000_000)
        let test11 = Period(year: 1501, month: 6, day: 15, hour: 11, minute: 30, second: 30, nano: 500_000_000)
        let test12 = Period(year: 1501, month: 6, day: 14, hour: 12, minute: 30, second: 30, nano: 500_000_000)
        let test13 = Period(year: 1501, month: 5, day: 15, hour: 12, minute: 30, second: 30, nano: 500_000_000)
        XCTAssertLessThan(test1, test8)
        XCTAssertLessThan(test1, test9)
        XCTAssertLessThan(test1, test10)
        XCTAssertLessThan(test1, test11)
        XCTAssertLessThan(test1, test12)
        XCTAssertLessThan(test1, test13)
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
        var localDate = LocalDateTime(year: 1000, month: 1, day: 1, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        var zonedDate = ZonedDateTime(year: 1000, month: 1, day: 1, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
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
        
        localDate += addPeriod
        zonedDate += addPeriod
        
        XCTAssertEqual(localDate.year, 1000)
        XCTAssertEqual(localDate.month, 2)
        XCTAssertEqual(localDate.day, 4)
        XCTAssertEqual(localDate.hour, 11)
        XCTAssertEqual(localDate.minute, 59)
        XCTAssertEqual(localDate.second, 18)
        XCTAssertEqual(localDate.nano, 1573)
        
        XCTAssertEqual(zonedDate.year, 1000)
        XCTAssertEqual(zonedDate.month, 2)
        XCTAssertEqual(zonedDate.day, 4)
        XCTAssertEqual(zonedDate.hour, 11)
        XCTAssertEqual(zonedDate.minute, 59)
        XCTAssertEqual(zonedDate.second, 18)
        XCTAssertEqual(zonedDate.nano, 1573)
        
        var period1 = 1.year
        let period2 = 2.month
        
        let sumPeriod = period1 + period2
        let checkPeriod = Period(year: 1, month: 2)
        XCTAssertEqual(sumPeriod, checkPeriod)
        
        period1 += period2
        XCTAssertEqual(period1, checkPeriod)
    }

    func testSubtractOperator() {
        var localDate = LocalDateTime(year: 1000, month: 1, day: 7, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        var zonedDate = ZonedDateTime(year: 1000, month: 1, day: 7, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
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
        
        localDate -= addPeriod
        zonedDate -= addPeriod
        
        XCTAssertEqual(localDate.year, 999)
        XCTAssertEqual(localDate.month, 12)
        XCTAssertEqual(localDate.day, 4)
        XCTAssertEqual(localDate.hour, 11)
        XCTAssertEqual(localDate.minute, 43)
        XCTAssertEqual(localDate.second, 18)
        XCTAssertEqual(localDate.nano, 1573)
        
        XCTAssertEqual(zonedDate.year, 999)
        XCTAssertEqual(zonedDate.month, 12)
        XCTAssertEqual(zonedDate.day, 4)
        XCTAssertEqual(zonedDate.hour, 11)
        XCTAssertEqual(zonedDate.minute, 43)
        XCTAssertEqual(zonedDate.second, 18)
        XCTAssertEqual(zonedDate.nano, 1573)
        
        var period1 = 1.year
        let period2 = 2.month
        
        let subtractPeriod = period1 - period2
        let checkPeriod = Period(month: 10)
        XCTAssertEqual(subtractPeriod, checkPeriod)
        
        period1 -= period2
        XCTAssertEqual(period1, checkPeriod)
    }
    func testHashable() {
        let period = Period(year: 1, month: 1, day: 3, hour: 1, minute: 8, second: 1, nano: 10)
        
        #if swift(>=4.2)
        var hasher = Hasher()
        hasher.combine(1)
        hasher.combine(1)
        hasher.combine(3)
        hasher.combine(1)
        hasher.combine(8)
        hasher.combine(1)
        hasher.combine(10)
        XCTAssertEqual(
            period.hashValue, hasher.finalize()
        )
        #else
        let dateHash = Int(1).hashValue ^ (51 &* Int(1).hashValue) ^ (17 &* Int(3).hashValue)
        let timeHash = Int(1).hashValue ^ (51 &* Int(8).hashValue) ^ (17 &* Int(1).hashValue) ^ (13 &* Int(10).hashValue)
        XCTAssertEqual(
            period.hashValue,
            dateHash ^ (13 &* timeHash)
        )
        #endif
    }
    func testDescription() {
        let period1 = Period(year: 1, month: 1, day: 3, hour: 1, minute: 8, second: 1, nano: 10)
        let period2 = Period(year: 0, month: 0, day: 0, hour: 0, minute: 0, second: 0, nano: 0)
        XCTAssertEqual(period1.description, "0001Year 01Mon 03Day 01Hour 08Min 01.000000010Sec")
        XCTAssertEqual(period1.debugDescription, "0001Year 01Mon 03Day 01Hour 08Min 01.000000010Sec")
        #if swift(>=4.1) || (swift(>=3.3) && !swift(>=4.0))
        if let description = period1.playgroundDescription as? String {
            XCTAssertEqual(description, "0001Year 01Mon 03Day 01Hour 08Min 01.000000010Sec")
        }
        #else
        if case .text(let text) = period1.customPlaygroundQuickLook {
            XCTAssertEqual(text, "0001Year 01Mon 03Day 01Hour 08Min 01.000000010Sec")
        }
        #endif
        XCTAssertEqual(period2.description, "")
        XCTAssertEqual(period2.debugDescription, "")
        #if swift(>=4.1) || (swift(>=3.3) && !swift(>=4.0))
        if let description = period2.playgroundDescription as? String {
            XCTAssertEqual(description, "")
        }
        #else
        if case .text(let text) = period2.customPlaygroundQuickLook {
            XCTAssertEqual(text, "")
        }
        #endif
    }
    func testMirror() {
        let period = Period(year: 1, month: 1, day: 3, hour: 1, minute: 8, second: 1, nano: 10)
        
        var checkList = [
            "year": 1,
            "month": 1,
            "day": 3,
            "hour": 1,
            "minute": 8,
            "second": 1,
            "nano": 10
        ]
        for child in period.customMirror.children {
            XCTAssertEqual(checkList[child.label!], (child.value as? Int)!)
            checkList.removeValue(forKey: child.label!)
        }
        XCTAssertEqual(checkList.count, 0)
    }
#if swift(>=3.2)
    func testCodable() {
        let period1 = Period(year: 1, month: 1, day: 3, hour: 1, minute: 8, second: 1, nano: 10)
        let jsonString = String(data: try! JSONEncoder().encode(period1), encoding: .utf8)!

        let jsonData = jsonString.data(using: .utf8)!
        let period2 = try! JSONDecoder().decode(Period.self, from: jsonData)

        XCTAssertEqual(period1, period2)
    }
#endif

}
