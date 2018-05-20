import XCTest
import Foundation
import AnyDate

class ClockTests: XCTestCase {

    func testComparable() {
        let oldClock = Clock(identifier: .americaStLucia)
        let newClock = Clock.UTC
        let equalClock = Clock(identifier: .americaStLucia)

        XCTAssertLessThan(oldClock, newClock)
        XCTAssertGreaterThan(newClock, oldClock)
        XCTAssertLessThanOrEqual(oldClock, equalClock)
        XCTAssertGreaterThanOrEqual(oldClock, equalClock)
        XCTAssertEqual(oldClock, equalClock)
        XCTAssertLessThan(oldClock, newClock)
    }
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
        let autoUpdatingCurrent = Clock.autoupdatingCurrent
        let current = Clock.current

        XCTAssertEqual(autoUpdatingCurrent.offsetSecond, timeZone.secondsFromGMT())
        XCTAssertEqual(current.offsetSecond, timeZone.secondsFromGMT())
    }
    func testIdentifier() {
        let timeZone = TimeZone.current

        let clock1 = Clock(identifier: .americaStLucia)
        let timeZone1 = TimeZone(identifier: "America/St_Lucia")!
        XCTAssertEqual(clock1.offsetSecond, timeZone1.secondsFromGMT())

        let clock2 = Clock(identifier: "Europe/Vilnius")!
        let timeZone2 = TimeZone(identifier: "Europe/Vilnius")!
        XCTAssertEqual(clock2.offsetSecond, timeZone2.secondsFromGMT())

        let clock3 = Clock(identifier: "TEST IDENTIFIER")
        XCTAssertEqual(clock3, nil)

        let clock4 = Clock(identifier: .current)
        XCTAssertEqual(clock4.offsetSecond, timeZone.secondsFromGMT())

        let clock5 = Clock(identifier: .autoUpdatingCurrent)
        XCTAssertEqual(clock5.offsetSecond, timeZone.secondsFromGMT())
    }
    func testOffsetSecond() {
        let clock = Clock(offsetSecond: 10800)
        XCTAssertEqual(clock.offsetSecond, 10800)
    }
    func testOffsetMinute() {
        let clock = Clock(offsetMinute: 180)
        XCTAssertEqual(clock.offsetSecond, 10800)
    }
    func testOffsetHour() {
        let clock = Clock(offsetHour: 3)
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
    func testHashable() {
        let clock = Clock(offsetSecond: 10860)
        XCTAssertEqual(clock.hashValue, Int(10860).hashValue)
    }
    func testDescription() {
        let clock = Clock(offsetSecond: 10860)
        XCTAssertEqual(clock.description, "03:01:00.000000000")
        XCTAssertEqual(clock.debugDescription, "03:01:00.000000000")
        #if swift(>=4.1) || (swift(>=3.3) && !swift(>=4.0))
        if let description = clock.playgroundDescription as? String {
            XCTAssertEqual(description, "03:01:00.000000000")
        }
        #else
        if case .text(let text) = clock.customPlaygroundQuickLook {
            XCTAssertEqual(text, "03:01:00.000000000")
        }
        #endif
    }
    func testMirror() {
        let clock = Clock(offsetSecond: 10860)
        
        var checkList = [
            "offsetSecond": 10860
        ]
        for child in clock.customMirror.children {
            XCTAssertEqual(checkList[child.label!]!, (child.value as? Int)!)
            checkList.removeValue(forKey: child.label!)
        }
        XCTAssertEqual(checkList.count, 0)
    }
#if swift(>=3.2)
    func testCodable() {
        let clock1 = Clock(offsetSecond: 10860)
        let jsonString = String(data: try! JSONEncoder().encode(clock1), encoding: .utf8)!

        let jsonData = jsonString.data(using: .utf8)!
        let clock2 = try! JSONDecoder().decode(Clock.self, from: jsonData)

        XCTAssertEqual(clock1, clock2)
    }
#endif

}
