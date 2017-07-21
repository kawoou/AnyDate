import XCTest
import Foundation
import DateTime

class LocalDateTimeTests: XCTestCase {

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
		let newDate = LocalDateTime(year: 1627, month: 2, day: 10, hour: 14, minute: 2, second: 18, nanoOfSecond: 1574)
		let equalDate = LocalDateTime(year: 1627, month: 2, day: 10, hour: 14, minute: 2, second: 18, nanoOfSecond: 1573)

		XCTAssertLessThan(min, oldDate)
		XCTAssertGreaterThan(max, newDate)
		XCTAssertLessThanOrEqual(oldDate, equalDate)
		XCTAssertGreaterThanOrEqual(oldDate, equalDate)
		XCTAssertEqual(oldDate, equalDate)
		XCTAssertLessThan(oldDate, newDate)
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

		let localDate = LocalDateTime(date, timeZone: utcCalendar.timeZone)
		XCTAssertEqual(localDate.year, utcCalendar.component(.year, from: date))
		XCTAssertEqual(localDate.month, utcCalendar.component(.month, from: date))
		XCTAssertEqual(localDate.day, utcCalendar.component(.day, from: date))
		XCTAssertEqual(localDate.hour, utcCalendar.component(.hour, from: date))
		XCTAssertEqual(localDate.minute, utcCalendar.component(.minute, from: date))
		XCTAssertEqual(localDate.second, utcCalendar.component(.second, from: date))
		XCTAssertEqual(localDate.nano, utcCalendar.component(.nanosecond, from: date))
	}
	func testFormat() {
		let date = LocalDateTime(year: 2017, month: 7, day: 24, hour: 3, minute: 46, second: 42, nanoOfSecond: 57_328_029)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy--MM-dd HH::mm:ss.SSS"

		XCTAssertEqual(date.format(dateFormatter), "2017--07-24 03::46:42.057")
	}
	func testUntil() {
		let oldDate = LocalDateTime(year: 1627, month: 2, day: 10, hour: 14, minute: 2, second: 18, nanoOfSecond: 1573)
		let newDate = LocalDateTime(year: 1628, month: 3, day: 12, hour: 15, minute: 3, second: 19, nanoOfSecond: 1574)

		XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .year), 1)
		XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .month), 13)
		XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .weekday), 56)
		XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .day), 397)
		XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .hour), 9505)
		XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .minute), 570301)
		XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .second), 34_218_061)
		XCTAssertEqual(oldDate.until(endDateTime: newDate, component: .nanosecond), 34_218_061_000_000_001)
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
		XCTAssertEqual(date1.dayOfWeek, 5)

		let date2 = LocalDateTime(year: 1, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanoOfSecond: 0)
		XCTAssertEqual(date2.dayOfWeek, 6)

		let date3 = LocalDateTime(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanoOfSecond: 0)
		XCTAssertEqual(date3.dayOfWeek, 2)

		let date4 = LocalDateTime(year: 1969, month: 12, day: 31, hour: 0, minute: 0, second: 0, nanoOfSecond: 0)
		XCTAssertEqual(date4.dayOfWeek, 1)

		let date5 = LocalDateTime(year: 1517, month: 7, day: 18, hour: 0, minute: 0, second: 0, nanoOfSecond: 0)
		XCTAssertEqual(date5.dayOfWeek, 1)

		let date6 = LocalDateTime(year: -1, month: 12, day: 26, hour: 0, minute: 0, second: 0, nanoOfSecond: 0)
		XCTAssertEqual(date6.dayOfWeek, 5)
	}
	func testParse() {
		let date1 = LocalDateTime.parse("2014-11-12T12:44:52.123")!
		XCTAssertEqual(date1.year, 2014)
		XCTAssertEqual(date1.month, 11)
		XCTAssertEqual(date1.day, 12)
		XCTAssertEqual(date1.hour, 12)
		XCTAssertEqual(date1.minute, 44)
		XCTAssertEqual(date1.second, 52)
		XCTAssertGreaterThan(123_500_000, date1.nano)
		XCTAssertLessThanOrEqual(122_500_000, date1.nano)

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy--MM-dd...HH.mm.ss.SSS"
		let date2 = LocalDateTime.parse("2014--11-12...12.44.52.123", formatter: dateFormatter)
		XCTAssertEqual(date1, date2)
	}
	func testAddDate() {
		let oldDate = LocalDateTime(year: 1000, month: 1, day: 1, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
		let addDate = LocalDateTime(year: 0, month: 1, day: 3, hour: 0, minute: 8, second: 0, nanoOfSecond: 0)
		let newDate = oldDate + addDate
		XCTAssertEqual(newDate.year, 1000)
		XCTAssertEqual(newDate.month, 2)
		XCTAssertEqual(newDate.day, 4)
		XCTAssertEqual(newDate.hour, 11)
		XCTAssertEqual(newDate.minute, 59)
		XCTAssertEqual(newDate.second, 18)
		XCTAssertEqual(newDate.nano, 1573)
	}
	func testSubtractDate() {
		let oldDate = LocalDateTime(year: 1000, month: 1, day: 7, hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
		let addDate = LocalDateTime(year: 0, month: 1, day: 3, hour: 0, minute: 8, second: 0, nanoOfSecond: 0)
		let newDate = oldDate - addDate
		XCTAssertEqual(newDate.year, 999)
		XCTAssertEqual(newDate.month, 12)
		XCTAssertEqual(newDate.day, 4)
		XCTAssertEqual(newDate.hour, 11)
		XCTAssertEqual(newDate.minute, 43)
		XCTAssertEqual(newDate.second, 18)
		XCTAssertEqual(newDate.nano, 1573)
	}
	func testToDate() {
		let calendar = Calendar.current
		let localDate = LocalDateTime(year: 1999, month: 10, day: 31, hour: 11, minute: 51, second: 18, nanoOfSecond: 153_000_000)
    	let date = localDate.toDate()

    	XCTAssertEqual(calendar.component(.year, from: date), 1999)
		XCTAssertEqual(calendar.component(.month, from: date), 10)
		XCTAssertEqual(calendar.component(.day, from: date), 31)
		XCTAssertEqual(calendar.component(.hour, from: date), 11)
		XCTAssertEqual(calendar.component(.minute, from: date), 51)
		XCTAssertEqual(calendar.component(.second, from: date), 18)
		XCTAssertGreaterThanOrEqual(153_500_000, calendar.component(.nanosecond, from: date))
		XCTAssertLessThanOrEqual(152_500_000, calendar.component(.nanosecond, from: date))
	}

}