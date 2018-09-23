import XCTest
import Foundation
import AnyDate

class LocalTimeTests: XCTestCase {

    func testPropertySetter() {
        var min = LocalTime.min
        min.hour = 100
        min.minute = 2
        min.second = -12
        min.nano = -125_221

        XCTAssertEqual(min.hour, 100)
        XCTAssertEqual(min.minute, 1)
        XCTAssertEqual(min.second, 47)
        XCTAssertEqual(min.nano, 999_874_779)
    }
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
        let newTime1 = LocalTime(hour: 14, minute: 2, second: 18, nanoOfSecond: 1574)
        let newTime2 = LocalTime(hour: 14, minute: 2, second: 19, nanoOfSecond: 1574)
        let newTime3 = LocalTime(hour: 14, minute: 3, second: 19, nanoOfSecond: 1574)
        let newTime4 = LocalTime(hour: 15, minute: 3, second: 19, nanoOfSecond: 1574)
        let equalTime = LocalTime(hour: 14, minute: 2, second: 18, nanoOfSecond: 1573)

        XCTAssertLessThan(min, oldTime)
        XCTAssertGreaterThan(max, newTime1)
        XCTAssertLessThanOrEqual(oldTime, equalTime)
        XCTAssertGreaterThanOrEqual(oldTime, equalTime)
        XCTAssertLessThan(oldTime, newTime2)
        XCTAssertLessThan(oldTime, newTime3)
        XCTAssertLessThan(oldTime, newTime4)
        XCTAssertGreaterThan(newTime4, oldTime)
        XCTAssertGreaterThan(newTime3, oldTime)
        XCTAssertGreaterThan(newTime2, oldTime)
        XCTAssertGreaterThan(newTime1, oldTime)
        XCTAssertEqual(oldTime, equalTime)
        XCTAssertNotEqual(oldTime, newTime1)
        XCTAssertNotEqual(oldTime, newTime2)
        XCTAssertNotEqual(oldTime, newTime3)
        XCTAssertNotEqual(oldTime, newTime4)
        XCTAssertLessThan(oldTime, newTime1)

        /// #15 TestCode
        let test1 = LocalTime(hour: 12, minute: 30, second: 30, nanoOfSecond: 500_000_000)
        let test2 = LocalTime(hour: 11, minute: 30, second: 30, nanoOfSecond: 500_000_001)
        let test3 = LocalTime(hour: 11, minute: 30, second: 31, nanoOfSecond: 500_000_000)
        let test4 = LocalTime(hour: 11, minute: 31, second: 30, nanoOfSecond: 500_000_000)
        XCTAssertGreaterThan(test1, test2)
        XCTAssertGreaterThan(test1, test3)
        XCTAssertGreaterThan(test1, test4)

        let test5 = LocalTime(hour: 13, minute: 30, second: 30, nanoOfSecond: 499_999_999)
        let test6 = LocalTime(hour: 13, minute: 30, second: 29, nanoOfSecond: 500_000_000)
        let test7 = LocalTime(hour: 13, minute: 29, second: 30, nanoOfSecond: 500_000_000)
        XCTAssertLessThan(test1, test5)
        XCTAssertLessThan(test1, test6)
        XCTAssertLessThan(test1, test7)

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

        let localTime1 = LocalTime(clock: .UTC)
        let localTime2 = LocalTime(date, clock: .UTC)
        XCTAssertEqual(localTime2.hour, utcCalendar.component(.hour, from: date))
        XCTAssertEqual(localTime2.minute, utcCalendar.component(.minute, from: date))
        XCTAssertEqual(localTime2.second, utcCalendar.component(.second, from: date))
        XCTAssertEqual(localTime2.nano, utcCalendar.component(.nanosecond, from: date))
        XCTAssertGreaterThanOrEqual(localTime1, localTime2)

        let localTime3 = LocalTime(date, clock: Clock(offsetHour: 9))
        XCTAssertNotEqual(localTime2.nanoOfDay, localTime3.nanoOfDay)
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

        XCTAssertEqual(oldTime.until(endTime: newTime, component: .day), 0)
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
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!

        let localTime = LocalTime(hour: 14, minute: 2, second: 18, nanoOfSecond: 153_000_000)
        let date = localTime.toDate(clock: .UTC)

        XCTAssertEqual(calendar.component(.hour, from: date), 14)
        XCTAssertEqual(calendar.component(.minute, from: date), 2)
        XCTAssertEqual(calendar.component(.second, from: date), 18)
        XCTAssertGreaterThanOrEqual(153_500_000, calendar.component(.nanosecond, from: date))
        XCTAssertLessThanOrEqual(152_500_000, calendar.component(.nanosecond, from: date))
    }
    func testParse() {
        let time1 = LocalTime.parse("05:53:12", clock: .current)!
        XCTAssertEqual(time1.hour, 5)
        XCTAssertEqual(time1.minute, 53)
        XCTAssertEqual(time1.second, 12)

        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:::mm:ss"
        let time2 = LocalTime.parse("05:::53:12", formatter: dateFormatter1, clock: .current)
        XCTAssertEqual(time1, time2)

        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "HH::asdfs"
        let time3 = LocalTime.parse("05:::53:12", formatter: dateFormatter2, clock: .current)
        XCTAssertEqual(time3, nil)
    }
    func testAddTime() {
        var oldTime = LocalTime(hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let addTime = LocalTime(hour: 0, minute: 8, second: 0, nanoOfSecond: 0)
        let newTime = oldTime + addTime
        XCTAssertEqual(newTime.hour, 11)
        XCTAssertEqual(newTime.minute, 59)
        XCTAssertEqual(newTime.second, 18)
        XCTAssertEqual(newTime.nano, 1573)

        oldTime += addTime
        XCTAssertEqual(oldTime, newTime)
    }
    func testSubtractTime() {
        var oldTime = LocalTime(hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let addTime = LocalTime(hour: 0, minute: 8, second: 0, nanoOfSecond: 0)
        let newTime = oldTime - addTime
        XCTAssertEqual(newTime.hour, 11)
        XCTAssertEqual(newTime.minute, 43)
        XCTAssertEqual(newTime.second, 18)
        XCTAssertEqual(newTime.nano, 1573)

        oldTime -= addTime
        XCTAssertEqual(oldTime, newTime)
    }
    func testHashable() {
        let date = LocalTime(hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        
        #if swift(>=4.2)
        var hasher = Hasher()
        hasher.combine(11)
        hasher.combine(51)
        hasher.combine(18)
        hasher.combine(1573)
        XCTAssertEqual(
            date.hashValue, hasher.finalize()
        )
        #else
        XCTAssertEqual(
            date.hashValue,
            Int(11).hashValue ^ (51 &* Int(51).hashValue) ^ (17 &* Int(18).hashValue) ^ (13 &* Int(1573).hashValue)
        )
        #endif
    }
    func testDescription() {
        let date = LocalTime(hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        #if swift(>=4.1) || (swift(>=3.3) && !swift(>=4.0))
        if let description = date.playgroundDescription as? String {
            XCTAssertEqual(description, "11:51:18.000001573")
        }
        #else
        if case .text(let text) = date.customPlaygroundQuickLook {
            XCTAssertEqual(text, "11:51:18.000001573")
        }
        #endif
    }
    func testMirror() {
        let date = LocalTime(hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        
        var checkList = [
            "hour": 11,
            "minute": 51,
            "second": 18,
            "nano": 1573
        ]
        for child in date.customMirror.children {
            XCTAssertEqual(checkList[child.label!], (child.value as? Int)!)
            checkList.removeValue(forKey: child.label!)
        }
        XCTAssertEqual(checkList.count, 0)
    }
#if swift(>=3.2)
    func testCodable() {
        let date1 = LocalTime(hour: 11, minute: 51, second: 18, nanoOfSecond: 1573)
        let jsonString = String(data: try! JSONEncoder().encode(date1), encoding: .utf8)!

        let jsonData = jsonString.data(using: .utf8)!
        let date2 = try! JSONDecoder().decode(LocalTime.self, from: jsonData)

        XCTAssertEqual(date1, date2)
    }
#endif

}
