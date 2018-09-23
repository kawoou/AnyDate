import XCTest
import Foundation
import AnyDate

class LocalDateTests: XCTestCase {

    func testPropertySetter() {
        var min = LocalDate.min
        min.year = 100
        min.month = 2
        min.day = -12

        XCTAssertEqual(min.year, 100)
        XCTAssertEqual(min.month, 1)
        XCTAssertEqual(min.day, 19)
    }
    func testMinMaxRange() {
        let min = LocalDate.min
        let max = LocalDate.max

        XCTAssertEqual(min.year, -999_999_999)
        XCTAssertEqual(min.month, 1)
        XCTAssertEqual(min.day, 1)

        XCTAssertEqual(max.year, 999_999_999)
        XCTAssertEqual(max.month, 12)
        XCTAssertEqual(max.day, 31)
    }
    func testComparable() {
        let min = LocalDate.min
        let max = LocalDate.max

        let oldDate = LocalDate(year: 1627, month: 2, day: 10)
        let newDate1 = LocalDate(year: 1627, month: 2, day: 11)
        let newDate2 = LocalDate(year: 1627, month: 3, day: 11)
        let newDate3 = LocalDate(year: 1628, month: 2, day: 11)
        let equalDate = LocalDate(year: 1627, month: 2, day: 10)

        XCTAssertLessThan(min, oldDate)
        XCTAssertGreaterThan(max, newDate1)
        XCTAssertLessThanOrEqual(oldDate, equalDate)
        XCTAssertGreaterThanOrEqual(oldDate, equalDate)
        XCTAssertLessThan(oldDate, newDate2)
        XCTAssertGreaterThan(newDate3, oldDate)
        XCTAssertGreaterThan(newDate2, oldDate)
        XCTAssertGreaterThan(newDate1, oldDate)
        XCTAssertEqual(oldDate, equalDate)
        XCTAssertNotEqual(oldDate, newDate1)
        XCTAssertNotEqual(oldDate, newDate2)
        XCTAssertNotEqual(oldDate, newDate3)
        XCTAssertLessThan(oldDate, newDate1)

        /// #15 TestCode
        let test1 = LocalDate(year: 1500, month: 6, day: 15)
        let test2 = LocalDate(year: 1499, month: 6, day: 16)
        let test3 = LocalDate(year: 1499, month: 7, day: 15)
        XCTAssertGreaterThan(test1, test2)
        XCTAssertGreaterThan(test1, test3)

        let test4 = LocalDate(year: 1501, month: 6, day: 14)
        let test5 = LocalDate(year: 1501, month: 5, day: 15)
        XCTAssertLessThan(test1, test4)
        XCTAssertLessThan(test1, test5)
    }
    func testFixOverflow() {
        let date = LocalDate(year: 2000, month: 13, day: 32)
        XCTAssertEqual(date.year, 2001)
        XCTAssertEqual(date.month, 2)
        XCTAssertEqual(date.day, 1)
    }
    func testFixUnderflow() {
        let date = LocalDate(year: 2000, month: 0, day: -30)
        XCTAssertEqual(date.year, 1999)
        XCTAssertEqual(date.month, 10)
        XCTAssertEqual(date.day, 31)
    }
    func testFromEpochDay() {
        let date1 = LocalDate(epochDay: -354285)
        XCTAssertEqual(date1.year, 1000)
        XCTAssertEqual(date1.month, 1)
        XCTAssertEqual(date1.day, 1)

        let date2 = LocalDate(epochDay: -719528)
        XCTAssertEqual(date2.year, 0)
        XCTAssertEqual(date2.month, 1)
        XCTAssertEqual(date2.day, 1)
        
        let date3 = LocalDate(epochDay: 11016)
        XCTAssertEqual(date3.year, 2000)
        XCTAssertEqual(date3.month, 2)
        XCTAssertEqual(date3.day, 29)
    }
    func testToEpochDay() {
        let date = LocalDate(year: 1000, month: 1, day: 1)
        XCTAssertEqual(date.epochDay, -354285)
    }
    func testFromDayOfYear() {
        let date = LocalDate(year: 1, dayOfYear: 719163)
        XCTAssertEqual(date.year, 1970)
        XCTAssertEqual(date.month, 1)
        XCTAssertEqual(date.day, 1)
    }
    func testOtherTimeZone() {
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = TimeZone(identifier: "UTC")!

        let date = Date()

        let localDate1 = LocalDate(clock: Clock.UTC)
        let localDate2 = LocalDate(date, clock: Clock.UTC)
        XCTAssertEqual(localDate1.year, utcCalendar.component(.year, from: date))
        XCTAssertEqual(localDate1.month, utcCalendar.component(.month, from: date))
        XCTAssertEqual(localDate1.day, utcCalendar.component(.day, from: date))
        XCTAssertGreaterThanOrEqual(localDate1, localDate2)
    }
    func testFormat() {
        let date = LocalDate(year: 2017, month: 7, day: 24)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy--MM-dd"

        XCTAssertEqual(date.format(dateFormatter), "2017--07-24")
    }
    func testUntil() {
        let oldDate = LocalDate(year: 1627, month: 2, day: 10)
        let newDate1 = LocalDate(year: 1628, month: 3, day: 12)

        XCTAssertEqual(oldDate.until(endDate: newDate1, component: .year), 1)
        XCTAssertEqual(oldDate.until(endDate: newDate1, component: .month), 13)
        XCTAssertEqual(oldDate.until(endDate: newDate1, component: .weekday), 56)
        XCTAssertEqual(oldDate.until(endDate: newDate1, component: .day), 396)

        let newDate2 = LocalDate(year: 1628, month: 4, day: 11)
        XCTAssertEqual(newDate1.until(endDate: newDate2).year, 0)
        XCTAssertEqual(newDate1.until(endDate: newDate2).month, 0)
        XCTAssertEqual(newDate1.until(endDate: newDate2).day, 30)

        let newDate3 = LocalDate(year: 1628, month: 2, day: 13)
        XCTAssertEqual(newDate1.until(endDate: newDate3).year, -1)
        XCTAssertEqual(newDate1.until(endDate: newDate3).month, 11)
        XCTAssertEqual(newDate1.until(endDate: newDate3).day, 3)

        let period = oldDate.until(endDate: newDate1)
        XCTAssertEqual(period.year, 1)
        XCTAssertEqual(period.month, 1)
        XCTAssertEqual(period.day, 2)
        XCTAssertEqual(period.hour, 0)
        XCTAssertEqual(period.minute, 0)
        XCTAssertEqual(period.second, 0)
        XCTAssertEqual(period.nano, 0)
    }
    func testRange() {
        let date1 = LocalDate(year: 1628, month: 3, day: 12)
        let date2 = LocalDate(year: 1629, month: 2, day: 12)
        let date3 = LocalDate(year: -1, month: 1, day: 1)

        XCTAssertEqual(date1.range(.month).1, 31)
        XCTAssertEqual(date1.range(.weekday).1, 5)
        XCTAssertEqual(date1.range(.year).1, 366)
        XCTAssertEqual(date1.range(.weekOfMonth).1, 5)
        XCTAssertEqual(date2.range(.weekOfMonth).1, 4)
        XCTAssertEqual(date1.range(.era).1, 999_999_999)
        XCTAssertEqual(date3.range(.era).1, 1000_000_000)
    }
    func testMinus() {
        let date = LocalDate(year: 1628, month: 3, day: 12)

        let compareDate1 = LocalDate(year: 1627, month: 3, day: 12)
        let compareDate2 = LocalDate(year: 1628, month: 2, day: 12)
        let compareDate3 = LocalDate(year: 1628, month: 3, day: 11)
        let compareDate4 = LocalDate(year: 1628, month: 3, day: 5)

        let newDate1 = date.minus(year: 1)
        let newDate2 = date.minus(month: 1)
        let newDate3 = date.minus(day: 1)
        let newDate4 = date.minus(week: 1)

        XCTAssertEqual(newDate1, compareDate1)
        XCTAssertEqual(newDate2, compareDate2)
        XCTAssertEqual(newDate3, compareDate3)
        XCTAssertEqual(newDate4, compareDate4)
    }
    func testPlus() {
        let date = LocalDate(year: 1628, month: 3, day: 12)

        let compareDate1 = LocalDate(year: 1629, month: 3, day: 12)
        let compareDate2 = LocalDate(year: 1628, month: 4, day: 12)
        let compareDate3 = LocalDate(year: 1628, month: 3, day: 13)
        let compareDate4 = LocalDate(year: 1628, month: 3, day: 19)

        let newDate1 = date.plus(year: 1)
        let newDate2 = date.plus(month: 1)
        let newDate3 = date.plus(day: 1)
        let newDate4 = date.plus(week: 1)

        XCTAssertEqual(newDate1, compareDate1)
        XCTAssertEqual(newDate2, compareDate2)
        XCTAssertEqual(newDate3, compareDate3)
        XCTAssertEqual(newDate4, compareDate4)
    }
    func testWith() {
        let date = LocalDate(year: 1628, month: 3, day: 12)

        let compareDate1 = LocalDate(year: 1920, month: 3, day: 12)
        let compareDate2 = LocalDate(year: 1628, month: 12, day: 12)
        let compareDate3 = LocalDate(year: 1628, month: 3, day: 31)
        let compareDate4 = LocalDate(year: 1628, month: 5, day: 1)

        let newDate1 = date.with(year: 1920)
        let newDate2 = date.with(month: 12)
        let newDate3 = date.with(dayOfMonth: 31)
        let newDate4 = date.with(dayOfYear: 122)

        XCTAssertEqual(newDate1, compareDate1)
        XCTAssertEqual(newDate2, compareDate2)
        XCTAssertEqual(newDate3, compareDate3)
        XCTAssertEqual(newDate4, compareDate4)
    }
    func testToDate() {
        let calendar = Calendar.current
        let localDate = LocalDate(year: 1999, month: 10, day: 31)
        let date = localDate.toDate(clock: .current)

        XCTAssertEqual(calendar.component(.year, from: date), 1999)
        XCTAssertEqual(calendar.component(.month, from: date), 10)
        XCTAssertEqual(calendar.component(.day, from: date), 31)
    }
    func testIsLeapYear() {
        let date = LocalDate(year: 1628, month: 3, day: 12)
        XCTAssertTrue(date.isLeapYear())
    }
    func testLengthOfYear() {
        let date1 = LocalDate(year: 1628, month: 2, day: 12)
        XCTAssertEqual(date1.lengthOfYear(), 366)

        let date2 = LocalDate(year: 1629, month: 2, day: 12)
        XCTAssertEqual(date2.lengthOfYear(), 365)
    }
    func testLengthOfMonth() {
        let date = LocalDate(year: 1628, month: 2, day: 12)
        XCTAssertEqual(date.lengthOfMonth(), 29)
    }
    func testDayOfWeek() {
        /// This result of the test was refers Apple Calendar in macOS.

        let date1 = LocalDate(year: 1628, month: 3, day: 12)
        XCTAssertEqual(date1.dayOfWeek, 6)

        let date2 = LocalDate(year: 1, month: 1, day: 1)
        XCTAssertEqual(date2.dayOfWeek, 0)

        let date3 = LocalDate(year: 1970, month: 1, day: 1)
        XCTAssertEqual(date3.dayOfWeek, 3)

        let date4 = LocalDate(year: 1969, month: 12, day: 31)
        XCTAssertEqual(date4.dayOfWeek, 2)

        let date5 = LocalDate(year: 1517, month: 7, day: 18)
        XCTAssertEqual(date5.dayOfWeek, 2)

        let date6 = LocalDate(year: -1, month: 12, day: 26)
        XCTAssertEqual(date6.dayOfWeek, 6)
    }
    func testParse() {
        let date1 = LocalDate.parse("2014-11-12", clock: Clock.current)!
        XCTAssertEqual(date1.year, 2014)
        XCTAssertEqual(date1.month, 11)
        XCTAssertEqual(date1.day, 12)

        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy--MM-dd"
        let date2 = LocalDate.parse("2014--11-12", formatter: dateFormatter1, clock: Clock.current)
        XCTAssertEqual(date1, date2)

        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-asdf"
        let date3 = LocalDate.parse("2014--11-12", formatter: dateFormatter2, clock: Clock.current)
        XCTAssertEqual(date3, nil)
    }
    func testAddDate() {
        var oldDate = LocalDate(year: 1000, month: 1, day: 1)
        let addDate = LocalDate(month: 1, day: 3)
        let newDate = oldDate + addDate
        XCTAssertEqual(newDate.year, 1000)
        XCTAssertEqual(newDate.month, 2)
        XCTAssertEqual(newDate.day, 4)

        oldDate += addDate
        XCTAssertEqual(oldDate, newDate)
    }
    func testSubtractDate() {
        var oldDate = LocalDate(year: 1000, month: 1, day: 1)
        let addDate = LocalDate(month: 1, day: 3)
        let newDate = oldDate - addDate
        XCTAssertEqual(newDate.year, 999)
        XCTAssertEqual(newDate.month, 11)
        XCTAssertEqual(newDate.day, 28)

        oldDate -= addDate
        XCTAssertEqual(oldDate, newDate)
    }
    func testHashable() {
        let date = LocalDate(year: 1969, month: 12, day: 31)
        
        #if swift(>=4.2)
        var hasher = Hasher()
        hasher.combine(1969)
        hasher.combine(12)
        hasher.combine(31)
        XCTAssertEqual(
            date.hashValue, hasher.finalize()
        )
        #else
        XCTAssertEqual(
            date.hashValue,
            Int(1969).hashValue ^ (51 &* Int(12).hashValue) ^ (17 &* Int(31).hashValue)
        )
        #endif
    }
    func testDescription() {
        let date = LocalDate(year: 1969, month: 12, day: 31)
        XCTAssertEqual(date.description, "1969.12.31")
        XCTAssertEqual(date.debugDescription, "1969.12.31")
        #if swift(>=4.1) || (swift(>=3.3) && !swift(>=4.0))
        if let description = date.playgroundDescription as? String {
            XCTAssertEqual(description, "1969.12.31")
        }
        #else
        if case .text(let text) = date.customPlaygroundQuickLook {
            XCTAssertEqual(text, "1969.12.31")
        }
        #endif
    }
    func testMirror() {
        let date = LocalDate(year: 1969, month: 12, day: 31)
        
        var checkList = [
            "year": 1969,
            "month": 12,
            "day": 31
        ]
        for child in date.customMirror.children {
            XCTAssertEqual(checkList[child.label!], (child.value as? Int)!)
            checkList.removeValue(forKey: child.label!)
        }
        XCTAssertEqual(checkList.count, 0)
    }
#if swift(>=3.2)
    func testCodable() {
        let date1 = LocalDate(year: 1969, month: 12, day: 31)
        let jsonString = String(data: try! JSONEncoder().encode(date1), encoding: .utf8)!

        let jsonData = jsonString.data(using: .utf8)!
        let date2 = try! JSONDecoder().decode(LocalDate.self, from: jsonData)

        XCTAssertEqual(date1, date2)
    }
#endif

}
