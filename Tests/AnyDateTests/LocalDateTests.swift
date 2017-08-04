import XCTest
import Foundation
import AnyDate

class LocalDateTests: XCTestCase {

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
		let newDate = LocalDate(year: 1627, month: 2, day: 11)
		let equalDate = LocalDate(year: 1627, month: 2, day: 10)

		XCTAssertLessThan(min, oldDate)
		XCTAssertGreaterThan(max, newDate)
		XCTAssertLessThanOrEqual(oldDate, equalDate)
		XCTAssertGreaterThanOrEqual(oldDate, equalDate)
		XCTAssertEqual(oldDate, equalDate)
		XCTAssertLessThan(oldDate, newDate)
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
		let date = LocalDate(epochDay: -354285)
		XCTAssertEqual(date.year, 1000)
		XCTAssertEqual(date.month, 1)
		XCTAssertEqual(date.day, 1)
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

		let localDate = LocalDate(date, timeZone: utcCalendar.timeZone)
		XCTAssertEqual(localDate.year, utcCalendar.component(.year, from: date))
		XCTAssertEqual(localDate.month, utcCalendar.component(.month, from: date))
		XCTAssertEqual(localDate.day, utcCalendar.component(.day, from: date))
	}
	func testFormat() {
		let date = LocalDate(year: 2017, month: 7, day: 24)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy--MM-dd"

		XCTAssertEqual(date.format(dateFormatter), "2017--07-24")
	}
	func testUntil() {
		let oldDate = LocalDate(year: 1627, month: 2, day: 10)
		let newDate = LocalDate(year: 1628, month: 3, day: 12)

		XCTAssertEqual(oldDate.until(endDate: newDate, component: .year), 1)
		XCTAssertEqual(oldDate.until(endDate: newDate, component: .month), 13)
		XCTAssertEqual(oldDate.until(endDate: newDate, component: .weekday), 56)
		XCTAssertEqual(oldDate.until(endDate: newDate, component: .day), 396)

		let period = oldDate.until(endDate: newDate)
		XCTAssertEqual(period.year, 1)
		XCTAssertEqual(period.month, 1)
		XCTAssertEqual(period.day, 2)
	}
	func testRange() {
		let date = LocalDate(year: 1628, month: 3, day: 12)

		XCTAssertEqual(date.range(.month).1, 31)
		XCTAssertEqual(date.range(.weekday).1, 5)
		XCTAssertEqual(date.range(.year).1, 366)
		XCTAssertEqual(date.range(.weekOfMonth).1, 5)
		XCTAssertEqual(date.range(.era).1, 999_999_999)
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
    	let date = localDate.toDate()

    	XCTAssertEqual(calendar.component(.year, from: date), 1999)
		XCTAssertEqual(calendar.component(.month, from: date), 10)
		XCTAssertEqual(calendar.component(.day, from: date), 31)
	}
	func testIsLeapYear() {
		let date = LocalDate(year: 1628, month: 3, day: 12)
		XCTAssertTrue(date.isLeapYear())
	}
	func testLengthOfYear() {
		let date = LocalDate(year: 1628, month: 2, day: 12)
		XCTAssertEqual(date.lengthOfYear(), 366)
	}
	func testLengthOfMonth() {
		let date = LocalDate(year: 1628, month: 2, day: 12)
		XCTAssertEqual(date.lengthOfMonth(), 29)
	}
	func testDayOfWeek() {
		/// This result of the test was refers Apple Calendar in macOS.

		let date1 = LocalDate(year: 1628, month: 3, day: 12)
		XCTAssertEqual(date1.dayOfWeek, 5)

		let date2 = LocalDate(year: 1, month: 1, day: 1)
		XCTAssertEqual(date2.dayOfWeek, 6)

		let date3 = LocalDate(year: 1970, month: 1, day: 1)
		XCTAssertEqual(date3.dayOfWeek, 2)

		let date4 = LocalDate(year: 1969, month: 12, day: 31)
		XCTAssertEqual(date4.dayOfWeek, 1)

		let date5 = LocalDate(year: 1517, month: 7, day: 18)
		XCTAssertEqual(date5.dayOfWeek, 1)

		let date6 = LocalDate(year: -1, month: 12, day: 26)
		XCTAssertEqual(date6.dayOfWeek, 5)
	}
	func testParse() {
		let date1 = LocalDate.parse("2014-11-12")!
		XCTAssertEqual(date1.year, 2014)
		XCTAssertEqual(date1.month, 11)
		XCTAssertEqual(date1.day, 12)

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy--MM-dd"
		let date2 = LocalDate.parse("2014--11-12", formatter: dateFormatter)
		XCTAssertEqual(date1, date2)
	}
	func testAddDate() {
		let oldDate = LocalDate(year: 1000, month: 1, day: 1)
		let addDate = LocalDate(month: 1, day: 3)
		let newDate = oldDate + addDate
		XCTAssertEqual(newDate.year, 1000)
		XCTAssertEqual(newDate.month, 2)
		XCTAssertEqual(newDate.day, 4)
	}
	func testSubtractDate() {
		let oldDate = LocalDate(year: 1000, month: 1, day: 1)
		let addDate = LocalDate(month: 1, day: 3)
		let newDate = oldDate - addDate
		XCTAssertEqual(newDate.year, 999)
		XCTAssertEqual(newDate.month, 11)
		XCTAssertEqual(newDate.day, 28)
	}

}
