import XCTest
import Foundation
import AnyDate

#if swift(>=5.5)
/// Tests that verify Sendable conformance for all AnyDate types.
/// These tests will fail to compile if Sendable conformance is broken.
final class SendableTests: XCTestCase {

    func testInstantIsSendable() async {
        let instant = Instant()
        await withTaskGroup(of: Int64.self) { group in
            group.addTask {
                return instant.second
            }
            for await _ in group {}
        }
    }

    func testLocalDateIsSendable() async {
        let date = LocalDate(year: 2024, month: 1, day: 1)
        await withTaskGroup(of: Int.self) { group in
            group.addTask {
                return date.year
            }
            for await _ in group {}
        }
    }

    func testLocalTimeIsSendable() async {
        let time = LocalTime(hour: 12, minute: 0, second: 0)
        await withTaskGroup(of: Int.self) { group in
            group.addTask {
                return time.hour
            }
            for await _ in group {}
        }
    }

    func testLocalDateTimeIsSendable() async {
        let dateTime = LocalDateTime(year: 2024, month: 1, day: 1, hour: 12, minute: 0, second: 0)
        await withTaskGroup(of: Int.self) { group in
            group.addTask {
                return dateTime.year
            }
            for await _ in group {}
        }
    }

    func testClockIsSendable() async {
        let clock = Clock.UTC
        await withTaskGroup(of: Int.self) { group in
            group.addTask {
                return clock.offsetSecond
            }
            for await _ in group {}
        }
    }

    func testZonedDateTimeIsSendable() async {
        let zdt = ZonedDateTime(clock: .UTC)
        await withTaskGroup(of: Int.self) { group in
            group.addTask {
                return zdt.year
            }
            for await _ in group {}
        }
    }

    func testPeriodIsSendable() async {
        let period = 1.year
        await withTaskGroup(of: Int.self) { group in
            group.addTask {
                return period.year
            }
            for await _ in group {}
        }
    }

    func testClockIdentifierNameIsSendable() async {
        let identifier = ClockIdentifierName.utc
        await withTaskGroup(of: String.self) { group in
            group.addTask {
                return identifier.rawValue
            }
            for await _ in group {}
        }
    }

    func testConcurrentClockAccess() async {
        let clock = Clock.UTC

        await withTaskGroup(of: Int.self) { group in
            for _ in 0..<100 {
                group.addTask {
                    return clock.offsetSecond
                }
            }

            for await offset in group {
                XCTAssertEqual(offset, 0)
            }
        }
    }

    func testConcurrentDateTimeCreation() async {
        await withTaskGroup(of: LocalDateTime.self) { group in
            for i in 0..<100 {
                group.addTask {
                    return LocalDateTime(year: 2024, month: 1, day: (i % 28) + 1, hour: 12, minute: 0, second: 0)
                }
            }

            var count = 0
            for await _ in group {
                count += 1
            }
            XCTAssertEqual(count, 100)
        }
    }
}
#endif
