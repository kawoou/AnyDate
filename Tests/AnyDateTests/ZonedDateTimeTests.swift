import XCTest
import Foundation
import AnyDate

class ZonedDateTimeTests: XCTestCase {

    let utcTimeZone = TimeZone(identifier: "UTC")!

    func testPropertySetter() {
        var min = ZonedDateTime.min
        min.year = 100
        min.month = 2
        min.day = -12
        min.hour = 12
        min.minute = 2
        min.second = -12
        min.nano = -125_221
        
        XCTAssertEqual(min.year, 100)
        XCTAssertEqual(min.month, 1)
        XCTAssertEqual(min.day, 19)
        XCTAssertEqual(min.hour, 12)
        XCTAssertEqual(min.minute, 1)
        XCTAssertEqual(min.second, 47)
        XCTAssertEqual(min.nano, 999_874_779)
    }
    func testMinMaxRange() {
        let clock = Clock.current
        let min = ZonedDateTime.min
        let max = ZonedDateTime.max

        XCTAssertEqual(min.year, -999_999_999)
        XCTAssertEqual(min.month, 1)
        XCTAssertEqual(min.day, 1)
        XCTAssertEqual(min.hour, 0)
        XCTAssertEqual(min.minute, 0)
        XCTAssertEqual(min.second, 0)
        XCTAssertEqual(min.nano, 0)
        XCTAssertEqual(min.clock, clock)

        XCTAssertEqual(max.year, 999_999_999)
        XCTAssertEqual(max.month, 12)
        XCTAssertEqual(max.day, 31)
        XCTAssertEqual(max.hour, 23)
        XCTAssertEqual(max.minute, 59)
        XCTAssertEqual(max.second, 59)
        XCTAssertEqual(max.nano, 999_999_999)
        XCTAssertEqual(max.clock, clock)
    }
    func testComparable() {
        let min = ZonedDateTime.min
        let max = ZonedDateTime.max

        let oldDate = ZonedDateTime(year: 1627, month: 2, day: 10, hour: 14, minute: 2, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let newDate = ZonedDateTime(year: 1627, month: 2, day: 10, hour: 14, minute: 2, second: 18, nanoOfSecond: 1574, timeZone: self.utcTimeZone)
        let equalDate = ZonedDateTime(year: 1627, month: 2, day: 10, hour: 14, minute: 2, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)

        XCTAssertLessThan(min, oldDate)
        XCTAssertGreaterThan(max, newDate)
        XCTAssertLessThanOrEqual(oldDate, equalDate)
        XCTAssertGreaterThanOrEqual(oldDate, equalDate)
        XCTAssertEqual(oldDate, equalDate)
        XCTAssertLessThan(oldDate, newDate)

        /// #15 TestCode
        let test1 = ZonedDateTime(year: 1500, month: 6, day: 15, hour: 12, minute: 30, second: 30, nanoOfSecond: 500_000_000, timeZone: self.utcTimeZone)
        let test2 = ZonedDateTime(year: 1499, month: 6, day: 15, hour: 12, minute: 30, second: 30, nanoOfSecond: 500_000_001, timeZone: self.utcTimeZone)
        let test3 = ZonedDateTime(year: 1499, month: 6, day: 15, hour: 12, minute: 30, second: 31, nanoOfSecond: 500_000_000, timeZone: self.utcTimeZone)
        let test4 = ZonedDateTime(year: 1499, month: 6, day: 15, hour: 12, minute: 31, second: 30, nanoOfSecond: 500_000_000, timeZone: self.utcTimeZone)
        let test5 = ZonedDateTime(year: 1499, month: 6, day: 15, hour: 13, minute: 30, second: 30, nanoOfSecond: 500_000_000, timeZone: self.utcTimeZone)
        let test6 = ZonedDateTime(year: 1499, month: 6, day: 16, hour: 12, minute: 30, second: 30, nanoOfSecond: 500_000_000, timeZone: self.utcTimeZone)
        let test7 = ZonedDateTime(year: 1499, month: 7, day: 15, hour: 12, minute: 30, second: 30, nanoOfSecond: 500_000_000, timeZone: self.utcTimeZone)
        XCTAssertGreaterThan(test1, test2)
        XCTAssertGreaterThan(test1, test3)
        XCTAssertGreaterThan(test1, test4)
        XCTAssertGreaterThan(test1, test5)
        XCTAssertGreaterThan(test1, test6)
        XCTAssertGreaterThan(test1, test7)

        let test8 = ZonedDateTime(year: 1501, month: 6, day: 15, hour: 12, minute: 30, second: 30, nanoOfSecond: 499_999_999, timeZone: self.utcTimeZone)
        let test9 = ZonedDateTime(year: 1501, month: 6, day: 15, hour: 12, minute: 30, second: 29, nanoOfSecond: 500_000_000, timeZone: self.utcTimeZone)
        let test10 = ZonedDateTime(year: 1501, month: 6, day: 15, hour: 12, minute: 29, second: 30, nanoOfSecond: 500_000_000, timeZone: self.utcTimeZone)
        let test11 = ZonedDateTime(year: 1501, month: 6, day: 15, hour: 11, minute: 30, second: 30, nanoOfSecond: 500_000_000, timeZone: self.utcTimeZone)
        let test12 = ZonedDateTime(year: 1501, month: 6, day: 14, hour: 12, minute: 30, second: 30, nanoOfSecond: 500_000_000, timeZone: self.utcTimeZone)
        let test13 = ZonedDateTime(year: 1501, month: 5, day: 15, hour: 12, minute: 30, second: 30, nanoOfSecond: 500_000_000, timeZone: self.utcTimeZone)
        XCTAssertLessThan(test1, test8)
        XCTAssertLessThan(test1, test9)
        XCTAssertLessThan(test1, test10)
        XCTAssertLessThan(test1, test11)
        XCTAssertLessThan(test1, test12)
        XCTAssertLessThan(test1, test13)
    }
    func testFixOverflow() {
        let date = ZonedDateTime(year: 2000, month: 13, day: 32, hour: 14, minute: 61, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        XCTAssertEqual(date.year, 2001)
        XCTAssertEqual(date.month, 2)
        XCTAssertEqual(date.day, 1)
        XCTAssertEqual(date.hour, 15)
        XCTAssertEqual(date.minute, 1)
        XCTAssertEqual(date.second, 18)
        XCTAssertEqual(date.nano, 1573)
        XCTAssertEqual(date.timeZone, self.utcTimeZone)
    }
    func testFixUnderflow() {
        let date = ZonedDateTime(year: 2000, month: 0, day: -30, hour: 14, minute: -2, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        XCTAssertEqual(date.year, 1999)
        XCTAssertEqual(date.month, 10)
        XCTAssertEqual(date.day, 31)
        XCTAssertEqual(date.hour, 13)
        XCTAssertEqual(date.minute, 58)
        XCTAssertEqual(date.second, 18)
        XCTAssertEqual(date.nano, 1573)
        XCTAssertEqual(date.timeZone, self.utcTimeZone)
    }
    func testFromEpochDayAndNanoOfDay() {
        let date = ZonedDateTime(epochDay: -354285, nanoOfDay: 13_602_057_328_029, timeZone: self.utcTimeZone)
        XCTAssertEqual(date.year, 1000)
        XCTAssertEqual(date.month, 1)
        XCTAssertEqual(date.day, 1)
        XCTAssertEqual(date.hour, 3)
        XCTAssertEqual(date.minute, 46)
        XCTAssertEqual(date.second, 42)
        XCTAssertEqual(date.nano, 57_328_029)
        XCTAssertEqual(date.timeZone, self.utcTimeZone)
    }
    func testFromDateAndTime() {
        let date = ZonedDateTime(
            date: LocalDate(epochDay: -354285),
            time: LocalTime(nanoOfDay: 13_602_057_328_029),
            timeZone: self.utcTimeZone
        )
        XCTAssertEqual(date.year, 1000)
        XCTAssertEqual(date.month, 1)
        XCTAssertEqual(date.day, 1)
        XCTAssertEqual(date.hour, 3)
        XCTAssertEqual(date.minute, 46)
        XCTAssertEqual(date.second, 42)
        XCTAssertEqual(date.nano, 57_328_029)
        XCTAssertEqual(date.timeZone, self.utcTimeZone)
    }
    func testFromLocalDateTime() {
        let date = ZonedDateTime(
            LocalDateTime(
                date: LocalDate(epochDay: -354285),
                time: LocalTime(nanoOfDay: 13_602_057_328_029)
            ),
            timeZone: self.utcTimeZone
        )
        XCTAssertEqual(date.year, 1000)
        XCTAssertEqual(date.month, 1)
        XCTAssertEqual(date.day, 1)
        XCTAssertEqual(date.hour, 3)
        XCTAssertEqual(date.minute, 46)
        XCTAssertEqual(date.second, 42)
        XCTAssertEqual(date.nano, 57_328_029)
        XCTAssertEqual(date.timeZone, self.utcTimeZone)
    }
    func testOtherTimeZone() {
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = self.utcTimeZone

        let date = Date()

        let localDate1 = ZonedDateTime(timeZone: utcCalendar.timeZone)
        let localDate2 = ZonedDateTime(date, timeZone: utcCalendar.timeZone)
        XCTAssertEqual(localDate2.year, utcCalendar.component(.year, from: date))
        XCTAssertEqual(localDate2.month, utcCalendar.component(.month, from: date))
        XCTAssertEqual(localDate2.day, utcCalendar.component(.day, from: date))
        XCTAssertEqual(localDate2.hour, utcCalendar.component(.hour, from: date))
        XCTAssertEqual(localDate2.minute, utcCalendar.component(.minute, from: date))
        XCTAssertEqual(localDate2.second, utcCalendar.component(.second, from: date))
        XCTAssertEqual(localDate2.nano, utcCalendar.component(.nanosecond, from: date))
        XCTAssertGreaterThanOrEqual(localDate1, localDate2)
    }
    func testFormat() {
        let date = ZonedDateTime(year: 2017, month: 7, day: 24, hour: 3, minute: 46, second: 42, nanoOfSecond: 57_328_029, timeZone: self.utcTimeZone)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy--MM-dd HH::mm:ss.SSS"

        XCTAssertEqual(date.format(dateFormatter), "2017--07-24 03::46:42.057")
    }
    func testUntil() {
        let oldDate = ZonedDateTime(year: 1627, month: 2, day: 10, hour: 14, minute: 2, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let newDate = ZonedDateTime(year: 1628, month: 3, day: 12, hour: 15, minute: 3, second: 19, nanoOfSecond: 1574, timeZone: self.utcTimeZone)

        let period = oldDate.until(endDateTime: newDate)
        XCTAssertEqual(period.year, 1)
        XCTAssertEqual(period.month, 1)
        XCTAssertEqual(period.day, 2)
        XCTAssertEqual(period.hour, 1)
        XCTAssertEqual(period.minute, 1)
        XCTAssertEqual(period.second, 1)
        XCTAssertEqual(period.nano, 1)

        XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .year), 1)
        XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .month), 13)
        XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .weekday), 56)
        XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .day), 397)
        XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .hour), 9505)
        XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .minute), 570301)
        XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .second), 34_218_061)
        XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .nanosecond), 34_218_061_000_000_001)

        let compareDate1 = ZonedDateTime(year: 1628, month: 3, day: 12, hour: 15, minute: 3, second: 19, nanoOfSecond: 1574, timeZone: self.utcTimeZone)
        let compareDate2 = ZonedDateTime(year: 1628, month: 3, day: 12, hour: 15, minute: 3, second: 19, nanoOfSecond: 1574, timeZone: TimeZone(abbreviation: "KST")!)
        XCTAssertEqual(compareDate1.until(endDateTime: compareDate2, component: .hour), 9)
    }
    func testRange() {
        let date = ZonedDateTime(year: 1628, month: 3, day: 12, hour: 15, minute: 3, second: 19, nanoOfSecond: 1574, timeZone: self.utcTimeZone)

        XCTAssertEqual(date.range(.nanosecond).1, 999_999_999)
        XCTAssertEqual(date.range(.second).1, 59)
        XCTAssertEqual(date.range(.minute).1, 59)
        XCTAssertEqual(date.range(.hour).1, 23)
        XCTAssertEqual(date.range(.month).1, 31)
        XCTAssertEqual(date.range(.weekday).1, 5)
        XCTAssertEqual(date.range(.year).1, 366)
        XCTAssertEqual(date.range(.weekOfMonth).1, 5)
        XCTAssertEqual(date.range(.era).1, 999_999_999)
    }
    func testMinus() {
        let date = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)

        let compareDate1 = ZonedDateTime(year: 1999, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate2 = ZonedDateTime(year: 2000, month: 10, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate3 = ZonedDateTime(year: 2000, month: 11, day: 29, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate4 = ZonedDateTime(year: 2000, month: 11, day: 23, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate5 = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 10, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate6 = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 50, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate7 = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 17, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate8 = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1572, timeZone: self.utcTimeZone)

        let newDate1 = date.minus(year: 1)
        let newDate2 = date.minus(month: 1)
        let newDate3 = date.minus(day: 1)
        let newDate4 = date.minus(week: 1)
        let newDate5 = date.minus(hour: 1)
        let newDate6 = date.minus(minute: 1)
        let newDate7 = date.minus(second: 1)
        let newDate8 = date.minus(nano: 1)

        XCTAssertEqual(newDate1, compareDate1)
        XCTAssertEqual(newDate2, compareDate2)
        XCTAssertEqual(newDate3, compareDate3)
        XCTAssertEqual(newDate4, compareDate4)
        XCTAssertEqual(newDate5, compareDate5)
        XCTAssertEqual(newDate6, compareDate6)
        XCTAssertEqual(newDate7, compareDate7)
        XCTAssertEqual(newDate8, compareDate8)
    }
    func testPlus() {
        let date = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)

        let compareDate1 = ZonedDateTime(year: 2001, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate2 = ZonedDateTime(year: 2000, month: 12, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate3 = ZonedDateTime(year: 2000, month: 11, day: 31, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate4 = ZonedDateTime(year: 2000, month: 12, day: 7, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate5 = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 12, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate6 = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 52, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate7 = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 19, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate8 = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1574, timeZone: self.utcTimeZone)

        let newDate1 = date.plus(year: 1)
        let newDate2 = date.plus(month: 1)
        let newDate3 = date.plus(day: 1)
        let newDate4 = date.plus(week: 1)
        let newDate5 = date.plus(hour: 1)
        let newDate6 = date.plus(minute: 1)
        let newDate7 = date.plus(second: 1)
        let newDate8 = date.plus(nano: 1)

        XCTAssertEqual(newDate1, compareDate1)
        XCTAssertEqual(newDate2, compareDate2)
        XCTAssertEqual(newDate3, compareDate3)
        XCTAssertEqual(newDate4, compareDate4)
        XCTAssertEqual(newDate5, compareDate5)
        XCTAssertEqual(newDate6, compareDate6)
        XCTAssertEqual(newDate7, compareDate7)
        XCTAssertEqual(newDate8, compareDate8)
    }
    func testWith() {
        let date = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)

        let compareDate1 = ZonedDateTime(year: 1, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate2 = ZonedDateTime(year: 2000, month: 1, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate3 = ZonedDateTime(year: 2000, month: 11, day: 1, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate4 = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 1, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate5 = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 1, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate6 = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 1, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let compareDate7 = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1, timeZone: self.utcTimeZone)

        let newDate1 = date.with(year: 1)
        let newDate2 = date.with(month: 1)
        let newDate3 = date.with(day: 1)
        let newDate4 = date.with(hour: 1)
        let newDate5 = date.with(minute: 1)
        let newDate6 = date.with(second: 1)
        let newDate7 = date.with(nano: 1)

        XCTAssertEqual(newDate1, compareDate1)
        XCTAssertEqual(newDate2, compareDate2)
        XCTAssertEqual(newDate3, compareDate3)
        XCTAssertEqual(newDate4, compareDate4)
        XCTAssertEqual(newDate5, compareDate5)
        XCTAssertEqual(newDate6, compareDate6)
        XCTAssertEqual(newDate7, compareDate7)

        let timeZoneDate1 = date.with(zoneSameLocal: TimeZone(abbreviation: "KST")!)
        let timeZoneDate2 = date.with(zoneSameInstant: TimeZone(abbreviation: "KST")!)
        XCTAssertEqual(date.until(endDateTime: timeZoneDate1, component: .hour), 18)
        XCTAssertEqual(date.until(endDateTime: timeZoneDate2, component: .hour), 9)
    }
    func testIsLeapYear() {
        let date = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        XCTAssertTrue(date.isLeapYear())
    }
    func testLengthOfYear() {
        let date = ZonedDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        XCTAssertEqual(date.lengthOfYear(), 366)
    }
    func testLengthOfMonth() {
        let date = ZonedDateTime(year: 1628, month: 2, day: 12, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        XCTAssertEqual(date.lengthOfMonth(), 29)
    }
    func testDayOfWeek() {
        /// This result of the test was refers Apple Calendar in macOS.

        let date1 = ZonedDateTime(year: 1628, month: 3, day: 12, hour: 0, minute: 0, second: 0, nanoOfSecond: 0, timeZone: self.utcTimeZone)
        XCTAssertEqual(date1.dayOfWeek, 6)

        let date2 = ZonedDateTime(year: 1, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanoOfSecond: 0, timeZone: self.utcTimeZone)
        XCTAssertEqual(date2.dayOfWeek, 0)

        let date3 = ZonedDateTime(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanoOfSecond: 0, timeZone: self.utcTimeZone)
        XCTAssertEqual(date3.dayOfWeek, 3)

        let date4 = ZonedDateTime(year: 1969, month: 12, day: 31, hour: 0, minute: 0, second: 0, nanoOfSecond: 0, timeZone: self.utcTimeZone)
        XCTAssertEqual(date4.dayOfWeek, 2)

        let date5 = ZonedDateTime(year: 1517, month: 7, day: 18, hour: 0, minute: 0, second: 0, nanoOfSecond: 0, timeZone: self.utcTimeZone)
        XCTAssertEqual(date5.dayOfWeek, 2)

        let date6 = ZonedDateTime(year: -1, month: 12, day: 26, hour: 0, minute: 0, second: 0, nanoOfSecond: 0, timeZone: self.utcTimeZone)
        XCTAssertEqual(date6.dayOfWeek, 6)
    }
    func testParse() {
        let date1 = ZonedDateTime.parse("2014-11-12T12:44:52.123+00:00", timeZone: self.utcTimeZone)!
        XCTAssertEqual(date1.year, 2014)
        XCTAssertEqual(date1.month, 11)
        XCTAssertEqual(date1.day, 12)
        XCTAssertEqual(date1.hour, 12)
        XCTAssertEqual(date1.minute, 44)
        XCTAssertEqual(date1.second, 52)
        XCTAssertGreaterThan(123_500_000, date1.nano)
        XCTAssertLessThanOrEqual(122_500_000, date1.nano)
        XCTAssertEqual(date1.timeZone, self.utcTimeZone)

        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy--MM-dd...HH.mm.ss.SSSZZZZZ"
        let date2 = ZonedDateTime.parse("2014--11-12...12.44.52.123+00:00", formatter: dateFormatter1, timeZone: self.utcTimeZone)
        XCTAssertEqual(date1, date2)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy--sadgasdgasdg"
        let date3 = ZonedDateTime.parse("2014--11-12...12.44.52.123+00:00", formatter: dateFormatter2, timeZone: self.utcTimeZone)
        XCTAssertEqual(date3, nil)
        
        let date4 = ZonedDateTime.parse("2014sadg", timeZone: self.utcTimeZone)
        XCTAssertEqual(date4, nil)
    }
    func testAddDate() {
        var oldDate = ZonedDateTime(year: 1000, month: 1, day: 1, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let addDate = ZonedDateTime(year: 0, month: 1, day: 3, hour: 0, minute: 8, second: 0, nanoOfSecond: 0, timeZone: self.utcTimeZone)
        var newDate = oldDate + addDate
        XCTAssertEqual(newDate.year, 1000)
        XCTAssertEqual(newDate.month, 2)
        XCTAssertEqual(newDate.day, 4)
        XCTAssertEqual(newDate.hour, 11)
        XCTAssertEqual(newDate.minute, 59)
        XCTAssertEqual(newDate.second, 18)
        XCTAssertEqual(newDate.nano, 1573)
        
        oldDate += addDate
        XCTAssertEqual(oldDate, newDate)
        
        newDate = oldDate + addDate.localDateTime
        XCTAssertEqual(newDate.year, 1000)
        XCTAssertEqual(newDate.month, 3)
        XCTAssertEqual(newDate.day, 7)
        XCTAssertEqual(newDate.hour, 12)
        XCTAssertEqual(newDate.minute, 7)
        XCTAssertEqual(newDate.second, 18)
        XCTAssertEqual(newDate.nano, 1573)
        
        oldDate += addDate.localDateTime
        XCTAssertEqual(oldDate, newDate)
        
        newDate = oldDate + addDate.localDate
        XCTAssertEqual(newDate.year, 1000)
        XCTAssertEqual(newDate.month, 4)
        XCTAssertEqual(newDate.day, 10)
        XCTAssertEqual(newDate.hour, 12)
        XCTAssertEqual(newDate.minute, 7)
        XCTAssertEqual(newDate.second, 18)
        XCTAssertEqual(newDate.nano, 1573)
        
        oldDate += addDate.localDate
        XCTAssertEqual(oldDate, newDate)
        
        newDate = oldDate + addDate.localTime
        XCTAssertEqual(newDate.year, 1000)
        XCTAssertEqual(newDate.month, 4)
        XCTAssertEqual(newDate.day, 10)
        XCTAssertEqual(newDate.hour, 12)
        XCTAssertEqual(newDate.minute, 15)
        XCTAssertEqual(newDate.second, 18)
        XCTAssertEqual(newDate.nano, 1573)
        
        oldDate += addDate.localTime
        XCTAssertEqual(oldDate, newDate)
    }
    func testSubtractDate() {
        var oldDate = ZonedDateTime(year: 1000, month: 1, day: 7, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573, timeZone: self.utcTimeZone)
        let addDate = ZonedDateTime(year: 0, month: 1, day: 3, hour: 0, minute: 8, second: 0, nanoOfSecond: 0, timeZone: self.utcTimeZone)
        var newDate = oldDate - addDate
        XCTAssertEqual(newDate.year, 999)
        XCTAssertEqual(newDate.month, 12)
        XCTAssertEqual(newDate.day, 4)
        XCTAssertEqual(newDate.hour, 11)
        XCTAssertEqual(newDate.minute, 43)
        XCTAssertEqual(newDate.second, 18)
        XCTAssertEqual(newDate.nano, 1573)
        
        oldDate -= addDate
        XCTAssertEqual(oldDate, newDate)
        
        newDate = oldDate - addDate.localDateTime
        XCTAssertEqual(newDate.year, 999)
        XCTAssertEqual(newDate.month, 11)
        XCTAssertEqual(newDate.day, 1)
        XCTAssertEqual(newDate.hour, 11)
        XCTAssertEqual(newDate.minute, 35)
        XCTAssertEqual(newDate.second, 18)
        XCTAssertEqual(newDate.nano, 1573)
        
        oldDate -= addDate.localDateTime
        XCTAssertEqual(oldDate, newDate)
        
        newDate = oldDate - addDate.localDate
        XCTAssertEqual(newDate.year, 999)
        XCTAssertEqual(newDate.month, 9)
        XCTAssertEqual(newDate.day, 28)
        XCTAssertEqual(newDate.hour, 11)
        XCTAssertEqual(newDate.minute, 35)
        XCTAssertEqual(newDate.second, 18)
        XCTAssertEqual(newDate.nano, 1573)
        
        oldDate -= addDate.localDate
        XCTAssertEqual(oldDate, newDate)
        
        newDate = oldDate - addDate.localTime
        XCTAssertEqual(newDate.year, 999)
        XCTAssertEqual(newDate.month, 9)
        XCTAssertEqual(newDate.day, 28)
        XCTAssertEqual(newDate.hour, 11)
        XCTAssertEqual(newDate.minute, 27)
        XCTAssertEqual(newDate.second, 18)
        XCTAssertEqual(newDate.nano, 1573)
        
        oldDate -= addDate.localTime
        XCTAssertEqual(oldDate, newDate)
    }
    func testToDate() {
        var calendar = Calendar.current
        calendar.timeZone = self.utcTimeZone

        let localDate = ZonedDateTime(year: 1999, month: 10, day: 31, hour: 11, minute: 51, second: 18, nanoOfSecond: 153_000_000, clock: .UTC)
        let date = localDate.toDate(clock: .UTC)

        XCTAssertEqual(calendar.component(.year, from: date), 1999)
        XCTAssertEqual(calendar.component(.month, from: date), 10)
        XCTAssertEqual(calendar.component(.day, from: date), 31)
        XCTAssertEqual(calendar.component(.hour, from: date), 11)
        XCTAssertEqual(calendar.component(.minute, from: date), 51)
        XCTAssertEqual(calendar.component(.second, from: date), 18)
        XCTAssertGreaterThanOrEqual(153_500_000, calendar.component(.nanosecond, from: date))
        XCTAssertLessThanOrEqual(152_500_000, calendar.component(.nanosecond, from: date))
    }
    func testHashable() {
        let date = ZonedDateTime(year: 1999, month: 10, day: 31, hour: 11, minute: 51, second: 18, nanoOfSecond: 153_000_000, clock: .UTC)
        
        #if swift(>=4.2)
        var hasher = Hasher()
        hasher.combine(date.clock)
        hasher.combine(date.localDateTime)
        XCTAssertEqual(
            date.hashValue, hasher.finalize()
        )
        #else
        XCTAssertEqual(
            date.hashValue,
            date.clock.hashValue ^ (79 &* date.localDateTime.hashValue)
        )
        #endif
    }
    func testDescription() {
        let date = ZonedDateTime(year: 1999, month: 10, day: 31, hour: 11, minute: 51, second: 18, nanoOfSecond: 153_000_000, clock: .UTC)
        XCTAssertEqual(date.description, "1999.10.31T11:51:18.153000000(00:00:00.000000000)")
        XCTAssertEqual(date.debugDescription, "1999.10.31T11:51:18.153000000(00:00:00.000000000)")
        #if swift(>=4.1) || (swift(>=3.3) && !swift(>=4.0))
        if let description = date.playgroundDescription as? String {
            XCTAssertEqual(description, "1999.10.31T11:51:18.153000000(00:00:00.000000000)")
        }
        #else
        if case .text(let text) = date.customPlaygroundQuickLook {
            XCTAssertEqual(text, "1999.10.31T11:51:18.153000000(00:00:00.000000000)")
        }
        #endif
    }
    func testMirror() {
        let date = ZonedDateTime(year: 1999, month: 10, day: 31, hour: 11, minute: 51, second: 18, nanoOfSecond: 153_000_000, clock: .UTC)
        
        var checkList: [String: Any] = [
            "year": 1999,
            "month": 10,
            "day": 31,
            "hour": 11,
            "minute": 51,
            "second": 18,
            "nano": 153_000_000,
            "clock": Clock.UTC.description
        ]
        for child in date.customMirror.children {
            if child.label! == "clock" {
                XCTAssertEqual(checkList[child.label!] as! String, child.value as! String)
            } else {
                XCTAssertEqual(checkList[child.label!] as! Int, child.value as! Int)
            }
            checkList.removeValue(forKey: child.label!)
        }
        XCTAssertEqual(checkList.count, 0)
    }
#if swift(>=3.2)
    func testCodable() {
        let date1 = ZonedDateTime(year: 1999, month: 10, day: 31, hour: 11, minute: 51, second: 18, nanoOfSecond: 153_000_000, clock: .UTC)
        let jsonString = String(data: try! JSONEncoder().encode(date1), encoding: .utf8)!

        let jsonData = jsonString.data(using: .utf8)!
        let date2 = try! JSONDecoder().decode(ZonedDateTime.self, from: jsonData)

        XCTAssertEqual(date1, date2)
    }
#endif

}
