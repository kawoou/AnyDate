import XCTest
import Foundation
import AnyDate

class LocalDateTimeTests: XCTestCase {

    func testPropertySetter() {
        var min = LocalDateTime.min
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

        min.date = LocalDate(year: 100, month: 2, day: -12)
        min.time = LocalTime(hour: 12, minute: 2, second: -12, nanoOfSecond: -125_221)

        XCTAssertEqual(min.year, 100)
        XCTAssertEqual(min.month, 1)
        XCTAssertEqual(min.day, 19)
        XCTAssertEqual(min.hour, 12)
        XCTAssertEqual(min.minute, 1)
        XCTAssertEqual(min.second, 47)
        XCTAssertEqual(min.nano, 999_874_779)
    }
    func testMinMaxRange() {
        let min = LocalDateTime.min
        let max = LocalDateTime.max

        XCTAssertEqual(min.year, -999_999_999)
        XCTAssertEqual(min.month, 1)
        XCTAssertEqual(min.day, 1)
        XCTAssertEqual(min.hour, 0)
        XCTAssertEqual(min.minute, 0)
        XCTAssertEqual(min.second, 0)
        XCTAssertEqual(min.nano, 0)

        XCTAssertEqual(max.year, 999_999_999)
        XCTAssertEqual(max.month, 12)
        XCTAssertEqual(max.day, 31)
        XCTAssertEqual(max.hour, 23)
        XCTAssertEqual(max.minute, 59)
        XCTAssertEqual(max.second, 59)
        XCTAssertEqual(max.nano, 999_999_999)
    }
    func testComparable() {
        let min = LocalDateTime.min
        let max = LocalDateTime.max

        let oldDate = LocalDateTime(year: 1627, month: 2, day: 10, hour: 14, minute: 2, second: 18, nanoOfSecond: 1573)
        let newDate1 = LocalDateTime(year: 1627, month: 2, day: 10, hour: 14, minute: 2, second: 18, nanoOfSecond: 1574)
        let newDate2 = LocalDateTime(year: 1627, month: 2, day: 10, hour: 15, minute: 2, second: 18, nanoOfSecond: 1574)
        let equalDate = LocalDateTime(year: 1627, month: 2, day: 10, hour: 14, minute: 2, second: 18, nanoOfSecond: 1573)

        XCTAssertLessThan(min, oldDate)
        XCTAssertGreaterThan(max, newDate1)
        XCTAssertLessThanOrEqual(oldDate, equalDate)
        XCTAssertGreaterThanOrEqual(oldDate, equalDate)
        XCTAssertGreaterThan(newDate2, oldDate)
        XCTAssertEqual(oldDate, equalDate)
        XCTAssertLessThan(oldDate, newDate1)

        /// #15 TestCode
        let test1 = LocalDateTime(year: 1500, month: 6, day: 15, hour: 12, minute: 30, second: 30, nanoOfSecond: 500_000_000)
        let test2 = LocalDateTime(year: 1499, month: 6, day: 15, hour: 12, minute: 30, second: 30, nanoOfSecond: 500_000_001)
        let test3 = LocalDateTime(year: 1499, month: 6, day: 15, hour: 12, minute: 30, second: 31, nanoOfSecond: 500_000_000)
        let test4 = LocalDateTime(year: 1499, month: 6, day: 15, hour: 12, minute: 31, second: 30, nanoOfSecond: 500_000_000)
        let test5 = LocalDateTime(year: 1499, month: 6, day: 15, hour: 13, minute: 30, second: 30, nanoOfSecond: 500_000_000)
        let test6 = LocalDateTime(year: 1499, month: 6, day: 16, hour: 12, minute: 30, second: 30, nanoOfSecond: 500_000_000)
        let test7 = LocalDateTime(year: 1499, month: 7, day: 15, hour: 12, minute: 30, second: 30, nanoOfSecond: 500_000_000)
        XCTAssertGreaterThan(test1, test2)
        XCTAssertGreaterThan(test1, test3)
        XCTAssertGreaterThan(test1, test4)
        XCTAssertGreaterThan(test1, test5)
        XCTAssertGreaterThan(test1, test6)
        XCTAssertGreaterThan(test1, test7)

        let test8 = LocalDateTime(year: 1501, month: 6, day: 15, hour: 12, minute: 30, second: 30, nanoOfSecond: 499_999_999)
        let test9 = LocalDateTime(year: 1501, month: 6, day: 15, hour: 12, minute: 30, second: 29, nanoOfSecond: 500_000_000)
        let test10 = LocalDateTime(year: 1501, month: 6, day: 15, hour: 12, minute: 29, second: 30, nanoOfSecond: 500_000_000)
        let test11 = LocalDateTime(year: 1501, month: 6, day: 15, hour: 11, minute: 30, second: 30, nanoOfSecond: 500_000_000)
        let test12 = LocalDateTime(year: 1501, month: 6, day: 14, hour: 12, minute: 30, second: 30, nanoOfSecond: 500_000_000)
        let test13 = LocalDateTime(year: 1501, month: 5, day: 15, hour: 12, minute: 30, second: 30, nanoOfSecond: 500_000_000)
        XCTAssertLessThan(test1, test8)
        XCTAssertLessThan(test1, test9)
        XCTAssertLessThan(test1, test10)
        XCTAssertLessThan(test1, test11)
        XCTAssertLessThan(test1, test12)
        XCTAssertLessThan(test1, test13)
    }
    func testFixOverflow() {
        let date = LocalDateTime(year: 2000, month: 13, day: 32, hour: 14, minute: 61, second: 18, nanoOfSecond: 1573)
        XCTAssertEqual(date.year, 2001)
        XCTAssertEqual(date.month, 2)
        XCTAssertEqual(date.day, 1)
        XCTAssertEqual(date.hour, 15)
        XCTAssertEqual(date.minute, 1)
        XCTAssertEqual(date.second, 18)
        XCTAssertEqual(date.nano, 1573)
    }
    func testFixUnderflow() {
        let date = LocalDateTime(year: 2000, month: 0, day: -30, hour: 14, minute: -2, second: 18, nanoOfSecond: 1573)
        XCTAssertEqual(date.year, 1999)
        XCTAssertEqual(date.month, 10)
        XCTAssertEqual(date.day, 31)
        XCTAssertEqual(date.hour, 13)
        XCTAssertEqual(date.minute, 58)
        XCTAssertEqual(date.second, 18)
        XCTAssertEqual(date.nano, 1573)
    }
    func testFromEpochDayAndNanoOfDay() {
        let date = LocalDateTime(epochDay: -354285, nanoOfDay: 13_602_057_328_029)
        XCTAssertEqual(date.year, 1000)
        XCTAssertEqual(date.month, 1)
        XCTAssertEqual(date.day, 1)
        XCTAssertEqual(date.hour, 3)
        XCTAssertEqual(date.minute, 46)
        XCTAssertEqual(date.second, 42)
        XCTAssertEqual(date.nano, 57_328_029)
    }
    func testFromDateAndTime() {
        let date = LocalDateTime(
            date: LocalDate(epochDay: -354285),
            time: LocalTime(nanoOfDay: 13_602_057_328_029)
        )
        XCTAssertEqual(date.year, 1000)
        XCTAssertEqual(date.month, 1)
        XCTAssertEqual(date.day, 1)
        XCTAssertEqual(date.hour, 3)
        XCTAssertEqual(date.minute, 46)
        XCTAssertEqual(date.second, 42)
        XCTAssertEqual(date.nano, 57_328_029)
    }
    func testOtherTimeZone() {
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = TimeZone(identifier: "UTC")!

        let date = Date()

        let localDate1 = LocalDateTime(clock: Clock.UTC)
        let localDate2 = LocalDateTime(date, clock: Clock.UTC)
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
        let date = LocalDateTime(year: 2017, month: 7, day: 24, hour: 3, minute: 46, second: 42, nanoOfSecond: 57_328_029)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy--MM-dd HH::mm:ss.SSS"

        XCTAssertEqual(date.format(dateFormatter), "2017--07-24 03::46:42.057")
    }
    func testUntil() {
        let oldDate = LocalDateTime(year: 1627, month: 2, day: 10, hour: 14, minute: 2, second: 18, nanoOfSecond: 1573)
        let newDate1 = LocalDateTime(year: 1628, month: 3, day: 12, hour: 15, minute: 3, second: 19, nanoOfSecond: 1574)

        let period = oldDate.until(endDateTime: newDate1)
        XCTAssertEqual(period.year, 1)
        XCTAssertEqual(period.month, 1)
        XCTAssertEqual(period.day, 2)
        XCTAssertEqual(period.hour, 1)
        XCTAssertEqual(period.minute, 1)
        XCTAssertEqual(period.second, 1)
        XCTAssertEqual(period.nano, 1)

        XCTAssertEqual(oldDate.until(endDateTime: newDate1, component: .year), 1)
        XCTAssertEqual(oldDate.until(endDateTime: newDate1, component: .month), 13)
        XCTAssertEqual(oldDate.until(endDateTime: newDate1, component: .weekday), 56)
        XCTAssertEqual(oldDate.until(endDateTime: newDate1, component: .day), 397)
        XCTAssertEqual(oldDate.until(endDateTime: newDate1, component: .hour), 9505)
        XCTAssertEqual(oldDate.until(endDateTime: newDate1, component: .minute), 570301)
        XCTAssertEqual(oldDate.until(endDateTime: newDate1, component: .second), 34_218_061)
        XCTAssertEqual(oldDate.until(endDateTime: newDate1, component: .nanosecond), 34_218_061_000_000_001)
        
        let newDate2 = LocalDateTime(year: 1628, month: 3, day: 11, hour: 14, minute: 3, second: 19, nanoOfSecond: 1574)
        
        XCTAssertEqual(newDate1.until(endDateTime: newDate2, component: .year), 0)
        XCTAssertEqual(newDate1.until(endDateTime: newDate2, component: .month), 0)
        XCTAssertEqual(newDate1.until(endDateTime: newDate2, component: .weekday), 0)
        XCTAssertEqual(newDate1.until(endDateTime: newDate2, component: .day), -2)
        XCTAssertEqual(newDate1.until(endDateTime: newDate2, component: .hour), -25)
        XCTAssertEqual(newDate1.until(endDateTime: newDate2, component: .minute), -1500)
        XCTAssertEqual(newDate1.until(endDateTime: newDate2, component: .second), -90000)
        XCTAssertEqual(newDate1.until(endDateTime: newDate2, component: .nanosecond), -90000_000_000_000)
        
        let newDate3 = LocalDateTime(year: 1628, month: 3, day: 13, hour: 14, minute: 3, second: 19, nanoOfSecond: 1574)
        
        XCTAssertEqual(newDate1.until(endDateTime: newDate3, component: .year), 0)
        XCTAssertEqual(newDate1.until(endDateTime: newDate3, component: .month), 0)
        XCTAssertEqual(newDate1.until(endDateTime: newDate3, component: .weekday), 0)
        XCTAssertEqual(newDate1.until(endDateTime: newDate3, component: .day), 1)
        XCTAssertEqual(newDate1.until(endDateTime: newDate3, component: .hour), 23)
        XCTAssertEqual(newDate1.until(endDateTime: newDate3, component: .minute), 1380)
        XCTAssertEqual(newDate1.until(endDateTime: newDate3, component: .second), 82800)
        XCTAssertEqual(newDate1.until(endDateTime: newDate3, component: .nanosecond), 82800_000_000_000)
    }
    func testRange() {
        let date = LocalDateTime(year: 1628, month: 3, day: 12, hour: 15, minute: 3, second: 19, nanoOfSecond: 1574)

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
        let date = LocalDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)

        let compareDate1 = LocalDateTime(year: 1999, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let compareDate2 = LocalDateTime(year: 2000, month: 10, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let compareDate3 = LocalDateTime(year: 2000, month: 11, day: 29, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let compareDate4 = LocalDateTime(year: 2000, month: 11, day: 23, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let compareDate5 = LocalDateTime(year: 2000, month: 11, day: 30, hour: 10, minute: 51, second: 18, nanoOfSecond: 1573)
        let compareDate6 = LocalDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 50, second: 18, nanoOfSecond: 1573)
        let compareDate7 = LocalDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 17, nanoOfSecond: 1573)
        let compareDate8 = LocalDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1572)

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
        let date = LocalDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)

        let compareDate1 = LocalDateTime(year: 2001, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let compareDate2 = LocalDateTime(year: 2000, month: 12, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let compareDate3 = LocalDateTime(year: 2000, month: 11, day: 31, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let compareDate4 = LocalDateTime(year: 2000, month: 12, day: 7, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let compareDate5 = LocalDateTime(year: 2000, month: 11, day: 30, hour: 12, minute: 51, second: 18, nanoOfSecond: 1573)
        let compareDate6 = LocalDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 52, second: 18, nanoOfSecond: 1573)
        let compareDate7 = LocalDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 19, nanoOfSecond: 1573)
        let compareDate8 = LocalDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1574)

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
        let date = LocalDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)

        let compareDate1 = LocalDateTime(year: 1, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let compareDate2 = LocalDateTime(year: 2000, month: 1, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let compareDate3 = LocalDateTime(year: 2000, month: 11, day: 1, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let compareDate4 = LocalDateTime(year: 2000, month: 11, day: 30, hour: 1, minute: 51, second: 18, nanoOfSecond: 1573)
        let compareDate5 = LocalDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 1, second: 18, nanoOfSecond: 1573)
        let compareDate6 = LocalDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 1, nanoOfSecond: 1573)
        let compareDate7 = LocalDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1)

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
    }
    func testIsLeapYear() {
        let date = LocalDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        XCTAssertTrue(date.isLeapYear())
    }
    func testLengthOfYear() {
        let date = LocalDateTime(year: 2000, month: 11, day: 30, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        XCTAssertEqual(date.lengthOfYear(), 366)
    }
    func testLengthOfMonth() {
        let date = LocalDateTime(year: 1628, month: 2, day: 12, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        XCTAssertEqual(date.lengthOfMonth(), 29)
    }
    func testDayOfWeek() {
        /// This result of the test was refers Apple Calendar in macOS.

        let date1 = LocalDateTime(year: 1628, month: 3, day: 12, hour: 0, minute: 0, second: 0, nanoOfSecond: 0)
        XCTAssertEqual(date1.dayOfWeek, 6)

        let date2 = LocalDateTime(year: 1, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanoOfSecond: 0)
        XCTAssertEqual(date2.dayOfWeek, 0)

        let date3 = LocalDateTime(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanoOfSecond: 0)
        XCTAssertEqual(date3.dayOfWeek, 3)

        let date4 = LocalDateTime(year: 1969, month: 12, day: 31, hour: 0, minute: 0, second: 0, nanoOfSecond: 0)
        XCTAssertEqual(date4.dayOfWeek, 2)

        let date5 = LocalDateTime(year: 1517, month: 7, day: 18, hour: 0, minute: 0, second: 0, nanoOfSecond: 0)
        XCTAssertEqual(date5.dayOfWeek, 2)

        let date6 = LocalDateTime(year: -1, month: 12, day: 26, hour: 0, minute: 0, second: 0, nanoOfSecond: 0)
        XCTAssertEqual(date6.dayOfWeek, 6)
    }
    func testParse() {
        let date1 = LocalDateTime.parse("2014-11-12T12:44:52.123", clock: .current)!
        XCTAssertEqual(date1.year, 2014)
        XCTAssertEqual(date1.month, 11)
        XCTAssertEqual(date1.day, 12)
        XCTAssertEqual(date1.hour, 12)
        XCTAssertEqual(date1.minute, 44)
        XCTAssertEqual(date1.second, 52)
        XCTAssertGreaterThan(123_500_000, date1.nano)
        XCTAssertLessThanOrEqual(122_500_000, date1.nano)

        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy--MM-dd...HH.mm.ss.SSS"
        let date2 = LocalDateTime.parse("2014--11-12...12.44.52.123", formatter: dateFormatter1, clock: .current)
        XCTAssertEqual(date1, date2)

        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy--asdfasdfsadf"
        let date3 = LocalDateTime.parse("2014--11-12...12.44.52.123", formatter: dateFormatter2, clock: .current)
        XCTAssertEqual(date3, nil)
    }
    func testAddDate() {
        var oldDate = LocalDateTime(year: 1000, month: 1, day: 1, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let addDate = LocalDateTime(year: 0, month: 1, day: 3, hour: 0, minute: 8, second: 0, nanoOfSecond: 0)
        var newDate = oldDate + addDate
        XCTAssertEqual(newDate.year, 1000)
        XCTAssertEqual(newDate.month, 2)
        XCTAssertEqual(newDate.day, 4)
        XCTAssertEqual(newDate.hour, 11)
        XCTAssertEqual(newDate.minute, 59)
        XCTAssertEqual(newDate.second, 18)
        XCTAssertEqual(newDate.nano, 1573)
        
        oldDate += addDate
        XCTAssertEqual(oldDate.year, 1000)
        XCTAssertEqual(oldDate.month, 2)
        XCTAssertEqual(oldDate.day, 4)
        XCTAssertEqual(oldDate.hour, 11)
        XCTAssertEqual(oldDate.minute, 59)
        XCTAssertEqual(oldDate.second, 18)
        XCTAssertEqual(oldDate.nano, 1573)
        
        newDate = oldDate + addDate.date
        XCTAssertEqual(newDate.year, 1000)
        XCTAssertEqual(newDate.month, 3)
        XCTAssertEqual(newDate.day, 7)
        XCTAssertEqual(newDate.hour, 11)
        XCTAssertEqual(newDate.minute, 59)
        XCTAssertEqual(newDate.second, 18)
        XCTAssertEqual(newDate.nano, 1573)
        
        oldDate += addDate.date
        XCTAssertEqual(oldDate.year, 1000)
        XCTAssertEqual(oldDate.month, 3)
        XCTAssertEqual(oldDate.day, 7)
        XCTAssertEqual(oldDate.hour, 11)
        XCTAssertEqual(oldDate.minute, 59)
        XCTAssertEqual(oldDate.second, 18)
        XCTAssertEqual(oldDate.nano, 1573)
        
        newDate = oldDate + addDate.time
        XCTAssertEqual(newDate.year, 1000)
        XCTAssertEqual(newDate.month, 3)
        XCTAssertEqual(newDate.day, 7)
        XCTAssertEqual(newDate.hour, 12)
        XCTAssertEqual(newDate.minute, 7)
        XCTAssertEqual(newDate.second, 18)
        XCTAssertEqual(newDate.nano, 1573)
        
        oldDate += addDate.time
        XCTAssertEqual(oldDate.year, 1000)
        XCTAssertEqual(oldDate.month, 3)
        XCTAssertEqual(oldDate.day, 7)
        XCTAssertEqual(oldDate.hour, 12)
        XCTAssertEqual(oldDate.minute, 7)
        XCTAssertEqual(oldDate.second, 18)
        XCTAssertEqual(oldDate.nano, 1573)
    }
    func testSubtractDate() {
        var oldDate = LocalDateTime(year: 1000, month: 1, day: 7, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let addDate = LocalDateTime(year: 0, month: 1, day: 3, hour: 0, minute: 8, second: 0, nanoOfSecond: 0)
        var newDate = oldDate - addDate
        XCTAssertEqual(newDate.year, 999)
        XCTAssertEqual(newDate.month, 12)
        XCTAssertEqual(newDate.day, 4)
        XCTAssertEqual(newDate.hour, 11)
        XCTAssertEqual(newDate.minute, 43)
        XCTAssertEqual(newDate.second, 18)
        XCTAssertEqual(newDate.nano, 1573)
        
        oldDate -= addDate
        XCTAssertEqual(oldDate.year, 999)
        XCTAssertEqual(oldDate.month, 12)
        XCTAssertEqual(oldDate.day, 4)
        XCTAssertEqual(oldDate.hour, 11)
        XCTAssertEqual(oldDate.minute, 43)
        XCTAssertEqual(oldDate.second, 18)
        XCTAssertEqual(oldDate.nano, 1573)
        
        newDate = oldDate - addDate.date
        XCTAssertEqual(newDate.year, 999)
        XCTAssertEqual(newDate.month, 11)
        XCTAssertEqual(newDate.day, 1)
        XCTAssertEqual(newDate.hour, 11)
        XCTAssertEqual(newDate.minute, 43)
        XCTAssertEqual(newDate.second, 18)
        XCTAssertEqual(newDate.nano, 1573)
        
        oldDate -= addDate.date
        XCTAssertEqual(oldDate.year, 999)
        XCTAssertEqual(oldDate.month, 11)
        XCTAssertEqual(oldDate.day, 1)
        XCTAssertEqual(oldDate.hour, 11)
        XCTAssertEqual(oldDate.minute, 43)
        XCTAssertEqual(oldDate.second, 18)
        XCTAssertEqual(oldDate.nano, 1573)
        
        newDate = oldDate - addDate.time
        XCTAssertEqual(newDate.year, 999)
        XCTAssertEqual(newDate.month, 11)
        XCTAssertEqual(newDate.day, 1)
        XCTAssertEqual(newDate.hour, 11)
        XCTAssertEqual(newDate.minute, 35)
        XCTAssertEqual(newDate.second, 18)
        XCTAssertEqual(newDate.nano, 1573)
        
        oldDate -= addDate.time
        XCTAssertEqual(oldDate.year, 999)
        XCTAssertEqual(oldDate.month, 11)
        XCTAssertEqual(oldDate.day, 1)
        XCTAssertEqual(oldDate.hour, 11)
        XCTAssertEqual(oldDate.minute, 35)
        XCTAssertEqual(oldDate.second, 18)
        XCTAssertEqual(oldDate.nano, 1573)
    }
    func testToDate() {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!

        let localDate = LocalDateTime(year: 1999, month: 10, day: 31, hour: 11, minute: 51, second: 18, nanoOfSecond: 153_000_000)
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
        let date = LocalDateTime(year: 1999, month: 10, day: 31, hour: 11, minute: 51, second: 18, nanoOfSecond: 153_000_000)
        
        #if swift(>=4.2)
        var hasher = Hasher()
        hasher.combine(date.date)
        hasher.combine(date.time)
        XCTAssertEqual(
            date.hashValue, hasher.finalize()
        )
        #else
        XCTAssertEqual(
            date.hashValue,
            date.date.hashValue ^ (13 &* date.time.hashValue)
        )
        #endif
    }
    func testDescription() {
        let date = LocalDateTime(year: 1999, month: 10, day: 31, hour: 11, minute: 51, second: 18, nanoOfSecond: 153_000_000)
        XCTAssertEqual(date.description, "1999.10.31T11:51:18.153000000")
        XCTAssertEqual(date.debugDescription, "1999.10.31T11:51:18.153000000")
        #if swift(>=4.1) || (swift(>=3.3) && !swift(>=4.0))
        if let description = date.playgroundDescription as? String {
            XCTAssertEqual(description, "1999.10.31T11:51:18.153000000")
        }
        #else
        if case .text(let text) = date.customPlaygroundQuickLook {
            XCTAssertEqual(text, "1999.10.31T11:51:18.153000000")
        }
        #endif
    }
    func testMirror() {
        let date = LocalDateTime(year: 1999, month: 10, day: 31, hour: 11, minute: 51, second: 18, nanoOfSecond: 153_000_000)
        
        var checkList = [
            "year": 1999,
            "month": 10,
            "day": 31,
            "hour": 11,
            "minute": 51,
            "second": 18,
            "nano": 153_000_000
        ]
        for child in date.customMirror.children {
            XCTAssertEqual(checkList[child.label!], (child.value as? Int)!)
            checkList.removeValue(forKey: child.label!)
        }
        XCTAssertEqual(checkList.count, 0)
    }
#if swift(>=3.2)
    func testCodable() {
        let date1 = LocalDateTime(year: 1999, month: 10, day: 31, hour: 11, minute: 51, second: 18, nanoOfSecond: 153_000_000)
        let jsonString = String(data: try! JSONEncoder().encode(date1), encoding: .utf8)!

        let jsonData = jsonString.data(using: .utf8)!
        let date2 = try! JSONDecoder().decode(LocalDateTime.self, from: jsonData)

        XCTAssertEqual(date1, date2)
    }
#endif

}
