import XCTest
import Foundation
import AnyDate

class LocalTimeTests: XCTestCase {

    func testStaticVaraibles() {
        let midNight = LocalTime.midNight
        let noon = LocalTime.noon
        let min = LocalTime.min
        let max = LocalTime.max

        XCTAssertEqual(midNight.hour, 0)
        XCTAssertEqual(midNight.minute, 0)
        XCTAssertEqual(midNight.second, 0)
        XCTAssertEqual(midNight.nano, 0)

        XCTAssertEqual(noon.hour, 12)
        XCTAssertEqual(noon.minute, 0)
        XCTAssertEqual(noon.second, 0)
        XCTAssertEqual(noon.nano, 0)

        XCTAssertEqual(midNight, min)

        XCTAssertEqual(max.hour, 23)
        XCTAssertEqual(max.minute, 59)
        XCTAssertEqual(max.second, 59)
        XCTAssertEqual(max.nano, 999_999_999)
    }
    func testStaticHour() {
        let time = LocalTime.hour(5)

        XCTAssertEqual(time.hour, 5)
        XCTAssertEqual(time.minute, 0)
        XCTAssertEqual(time.second, 0)
        XCTAssertEqual(time.nano, 0)
    }
    func testComparable() {
        let min = LocalTime.min
        let max = LocalTime.max

        let oldTime = LocalTime(hour: 14, minute: 2, second: 18, nanoOfSecond: 1573)
        let newTime = LocalTime(hour: 14, minute: 2, second: 18, nanoOfSecond: 1574)
        let equalTime = LocalTime(hour: 14, minute: 2, second: 18, nanoOfSecond: 1573)

        XCTAssertLessThan(min, oldTime)
        XCTAssertGreaterThan(max, newTime)
        XCTAssertLessThanOrEqual(oldTime, equalTime)
        XCTAssertGreaterThanOrEqual(oldTime, equalTime)
        XCTAssertEqual(oldTime, equalTime)
        XCTAssertLessThan(oldTime, newTime)
    }
    func testFixOverflow() {
        let time = LocalTime(hour: 14, minute: 61, second: 18, nanoOfSecond: 1573)
        XCTAssertEqual(time.hour, 15)
        XCTAssertEqual(time.minute, 1)
        XCTAssertEqual(time.second, 18)
        XCTAssertEqual(time.nano, 1573)
    }
    func testFixUnderflow() {
        let time = LocalTime(hour: 14, minute: -2, second: 18, nanoOfSecond: 1573)
        XCTAssertEqual(time.hour, 13)
        XCTAssertEqual(time.minute, 58)
        XCTAssertEqual(time.second, 18)
        XCTAssertEqual(time.nano, 1573)
    }
    func testFromNanoOfDay() {
        let time = LocalTime(nanoOfDay: 13_602_057_328_029)
        XCTAssertEqual(time.hour, 3)
        XCTAssertEqual(time.minute, 46)
        XCTAssertEqual(time.second, 42)
        XCTAssertEqual(time.nano, 57_328_029)
    }
    func testToNanoOfDay() {
        let time = LocalTime(hour: 3, minute: 46, second: 42, nanoOfSecond: 57_328_029)
        XCTAssertEqual(time.nanoOfDay, 13_602_057_328_029)
    }
    func testToSecondOfDay() {
        let time = LocalTime(hour: 3, minute: 46, second: 42, nanoOfSecond: 57_328_029)
        XCTAssertEqual(time.secondOfDay, 13_602)    
    }
    func testFromSecondOfDay() {
        let time = LocalTime(secondOfDay: 13_602)
        XCTAssertEqual(time.hour, 3)
        XCTAssertEqual(time.minute, 46)
        XCTAssertEqual(time.second, 42)
        XCTAssertEqual(time.nano, 0)
    }
    func testOtherTimeZone() {
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = TimeZone(identifier: "UTC")!

        let date = Date()

        let localTime1 = LocalTime(date, timeZone: utcCalendar.timeZone)
        XCTAssertEqual(localTime1.hour, utcCalendar.component(.hour, from: date))
        XCTAssertEqual(localTime1.minute, utcCalendar.component(.minute, from: date))
        XCTAssertEqual(localTime1.second, utcCalendar.component(.second, from: date))
        XCTAssertEqual(localTime1.nano, utcCalendar.component(.nanosecond, from: date))

        let localTime2 = LocalTime(date, clock: Clock(offsetHour: 9))
        XCTAssertNotEqual(localTime1.nanoOfDay, localTime2.nanoOfDay)
    }
    func testFormat() {
        let time = LocalTime(hour: 3, minute: 46, second: 42, nanoOfSecond: 57_328_029)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"

        XCTAssertEqual(time.format(dateFormatter), "03:46:42.057")
    }
    func testUntil() {
        let oldTime = LocalTime(hour: 14, minute: 2, second: 18, nanoOfSecond: 1573)
        let newTime = LocalTime(hour: 15, minute: 3, second: 19, nanoOfSecond: 1574)
        
        let period = oldTime.until(endTime: newTime)
        XCTAssertEqual(period.year, 0)
        XCTAssertEqual(period.month, 0)
        XCTAssertEqual(period.day, 0)
        XCTAssertEqual(period.hour, 1)
        XCTAssertEqual(period.minute, 1)
        XCTAssertEqual(period.second, 1)
        XCTAssertEqual(period.nano, 1)

        XCTAssertEqual(oldTime.until(endTime: newTime, component: .hour), 1)
        XCTAssertEqual(oldTime.until(endTime: newTime, component: .minute), 61)
        XCTAssertEqual(oldTime.until(endTime: newTime, component: .second), 3661)
        XCTAssertEqual(oldTime.until(endTime: newTime, component: .nanosecond), 3661_000_000_001)
    }
    func testRange() {
        let time = LocalTime(hour: 14, minute: 2, second: 18, nanoOfSecond: 1573)

        XCTAssertEqual(time.range(.hour).1, 23)
        XCTAssertEqual(time.range(.minute).1, 59)
        XCTAssertEqual(time.range(.second).1, 59)
        XCTAssertEqual(time.range(.nanosecond).1, 999_999_999)
    }
    func testMinus() {
        let time = LocalTime(hour: 14, minute: 2, second: 18, nanoOfSecond: 1573)

        let compareTime1 = LocalTime(hour: 13, minute: 2, second: 18, nanoOfSecond: 1573)
        let compareTime2 = LocalTime(hour: 14, minute: 1, second: 18, nanoOfSecond: 1573)
        let compareTime3 = LocalTime(hour: 14, minute: 2, second: 17, nanoOfSecond: 1573)
        let compareTime4 = LocalTime(hour: 14, minute: 2, second: 18, nanoOfSecond: 1572)

        let newTime1 = time.minus(hour: 1)
        let newTime2 = time.minus(minute: 1)
        let newTime3 = time.minus(second: 1)
        let newTime4 = time.minus(nano: 1)

        XCTAssertEqual(newTime1, compareTime1)
        XCTAssertEqual(newTime2, compareTime2)
        XCTAssertEqual(newTime3, compareTime3)
        XCTAssertEqual(newTime4, compareTime4)
    }
    func testPlus() {
        let time = LocalTime(hour: 14, minute: 2, second: 18, nanoOfSecond: 1573)

        let compareTime1 = LocalTime(hour: 15, minute: 2, second: 18, nanoOfSecond: 1573)
        let compareTime2 = LocalTime(hour: 14, minute: 3, second: 18, nanoOfSecond: 1573)
        let compareTime3 = LocalTime(hour: 14, minute: 2, second: 19, nanoOfSecond: 1573)
        let compareTime4 = LocalTime(hour: 14, minute: 2, second: 18, nanoOfSecond: 1574)

        let newTime1 = time.plus(hour: 1)
        let newTime2 = time.plus(minute: 1)
        let newTime3 = time.plus(second: 1)
        let newTime4 = time.plus(nano: 1)

        XCTAssertEqual(newTime1, compareTime1)
        XCTAssertEqual(newTime2, compareTime2)
        XCTAssertEqual(newTime3, compareTime3)
        XCTAssertEqual(newTime4, compareTime4)
    }
    func testWith() {
        let time = LocalTime(hour: 14, minute: 2, second: 18, nanoOfSecond: 1573)

        let compareTime1 = LocalTime(hour: 23, minute: 2, second: 18, nanoOfSecond: 1573)
        let compareTime2 = LocalTime(hour: 14, minute: 9, second: 18, nanoOfSecond: 1573)
        let compareTime3 = LocalTime(hour: 14, minute: 2, second: 59, nanoOfSecond: 1573)
        let compareTime4 = LocalTime(hour: 14, minute: 2, second: 18, nanoOfSecond: 123_157_234)

        let newTime1 = time.with(hour: 23)
        let newTime2 = time.with(minute: 9)
        let newTime3 = time.with(second: 59)
        let newTime4 = time.with(nano: 123_157_234)

        XCTAssertEqual(newTime1, compareTime1)
        XCTAssertEqual(newTime2, compareTime2)
        XCTAssertEqual(newTime3, compareTime3)
        XCTAssertEqual(newTime4, compareTime4)
    }
    func testToDate() {
        let calendar = Calendar.current
        let localTime = LocalTime(hour: 14, minute: 2, second: 18, nanoOfSecond: 153_000_000)
        let date = localTime.toDate()

        XCTAssertEqual(calendar.component(.hour, from: date), 14)
        XCTAssertEqual(calendar.component(.minute, from: date), 2)
        XCTAssertEqual(calendar.component(.second, from: date), 18)
        XCTAssertGreaterThanOrEqual(153_500_000, calendar.component(.nanosecond, from: date))
        XCTAssertLessThanOrEqual(152_500_000, calendar.component(.nanosecond, from: date))
    }
    func testParse() {
        let time1 = LocalTime.parse("05:53:12")!
        XCTAssertEqual(time1.hour, 5)
        XCTAssertEqual(time1.minute, 53)
        XCTAssertEqual(time1.second, 12)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:::mm:ss"
        let time2 = LocalTime.parse("05:::53:12", formatter: dateFormatter)
        XCTAssertEqual(time1, time2)
    }
    func testAddTime() {
        let oldTime = LocalTime(hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let addTime = LocalTime(hour: 0, minute: 8, second: 0, nanoOfSecond: 0)
        let newTime = oldTime + addTime
        XCTAssertEqual(newTime.hour, 11)
        XCTAssertEqual(newTime.minute, 59)
        XCTAssertEqual(newTime.second, 18)
        XCTAssertEqual(newTime.nano, 1573)
    }
    func testSubtractTime() {
        let oldTime = LocalTime(hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let addTime = LocalTime(hour: 0, minute: 8, second: 0, nanoOfSecond: 0)
        let newTime = oldTime - addTime
        XCTAssertEqual(newTime.hour, 11)
        XCTAssertEqual(newTime.minute, 43)
        XCTAssertEqual(newTime.second, 18)
        XCTAssertEqual(newTime.nano, 1573)
    }

}
