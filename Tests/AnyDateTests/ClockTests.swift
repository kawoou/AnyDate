import XCTest
import Foundation
import AnyDate

class ClockTests: XCTestCase {

	func testUTC() {
		let utc = Clock.UTC
		XCTAssertEqual(utc.offsetSecond, 0)
	}
	func testGMT() {
		let gmt = Clock.GMT
		XCTAssertEqual(gmt.offsetSecond, 0)
	}
	func testCurrent() {
		let timeZone = TimeZone.current
		let current = Clock.current

		XCTAssertEqual(current.offsetSecond, timeZone.secondsFromGMT())
	}
	func testAutoUpdatingCurrent() {
		let timeZone = TimeZone.current
		let current = Clock.autoupdatingCurrent

		XCTAssertEqual(current.offsetSecond, timeZone.secondsFromGMT())	
	}
	func testIdentifier() {
		let clock1 = Clock(identifier: .americaStLucia)
		XCTAssertEqual(clock1.offsetSecond, -14400)

		let clock2 = Clock(identifier: "Europe/Vilnius")!
		XCTAssertEqual(clock2.offsetSecond, 10800)
	}
	func testOffsetSecond() {
		let clock = Clock(offsetSecond: 10800)
		XCTAssertEqual(clock.offsetSecond, 10800)
	}
	func testToTime() {
		let clock = Clock(identifier: .americaStLucia)
		let time = clock.toTime()

		XCTAssertEqual(time.hour, -4)
		XCTAssertEqual(time.minute, 0)
		XCTAssertEqual(time.second, 0)
		XCTAssertEqual(time.nano, 0)
	}
	func testToTimeZone() {
		let clock = Clock(offsetSecond: 10860)
		let timeZone = clock.toTimeZone()
		XCTAssertEqual(timeZone.secondsFromGMT(), 10860)
	}
	func testOffset() {
		let clock = Clock.offset(baseClock: Clock(identifier: .americaStLucia), offsetDuration: 100)
		XCTAssertEqual(clock.offsetSecond, -14300)
	}

}