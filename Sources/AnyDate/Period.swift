import Foundation

public struct Period {
    public var year: Int
    public var month: Int
    public var day: Int
    public var hour: Int
    public var minute: Int
    public var second: Int
    public var nano: Int

    public init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, nano: Int) {
    	self.nano = Int(nano)

    	self.second = self.nano / Int(LocalTime.Constant.nanosPerSecond) + second
    	self.nano %= Int(LocalTime.Constant.nanosPerSecond)

    	self.minute = self.second / LocalTime.Constant.secondsPerMinute + minute
    	self.second %= LocalTime.Constant.secondsPerMinute

    	self.hour = self.minute / LocalTime.Constant.minutesPerHour + hour
    	self.minute %= LocalTime.Constant.minutesPerHour

    	let days = self.hour / LocalTime.Constant.hoursPerDay + day
    	self.hour %= LocalTime.Constant.hoursPerDay

    	var newDate = LocalDate(year: year, month: month + 1, day: days + 1)
        self.year = newDate.year
        self.month = newDate.month - 1
        self.day = newDate.day - 1
    }
}

/// LocalDateTime
public func + (lhs: LocalDateTime, rhs: Period) -> LocalDateTime {
    return LocalDateTime(
        year: lhs.year + rhs.year,
        month: lhs.month + rhs.month,
        day: lhs.day + rhs.day,
        hour: lhs.hour + rhs.hour,
        minute: lhs.minute + rhs.minute,
        second: lhs.second + rhs.second,
        nanoOfSecond: lhs.nano + rhs.nano
    )
}
public func += (lhs: inout LocalDateTime, rhs: Period) {
    lhs.year += rhs.year
    lhs.month += rhs.month
    lhs.day += rhs.day
    lhs.hour += rhs.hour
    lhs.minute += rhs.minute
    lhs.second += rhs.second
    lhs.nano += rhs.nano
}
public func - (lhs: LocalDateTime, rhs: Period) -> LocalDateTime {
    return LocalDateTime(
        year: lhs.year - rhs.year,
        month: lhs.month - rhs.month,
        day: lhs.day - rhs.day,
        hour: lhs.hour - rhs.hour,
        minute: lhs.minute - rhs.minute,
        second: lhs.second - rhs.second,
        nanoOfSecond: lhs.nano - rhs.nano
    )
}
public func -= (lhs: inout LocalDateTime, rhs: Period) {
    lhs.year -= rhs.year
    lhs.month -= rhs.month
    lhs.day -= rhs.day
    lhs.hour -= rhs.hour
    lhs.minute -= rhs.minute
    lhs.second -= rhs.second
    lhs.nano -= rhs.nano
}

/// ZonedDateTime
public func + (lhs: ZonedDateTime, rhs: Period) -> ZonedDateTime {
    return ZonedDateTime(
        year: lhs.year + rhs.year,
        month: lhs.month + rhs.month,
        day: lhs.day + rhs.day,
        hour: lhs.hour + rhs.hour,
        minute: lhs.minute + rhs.minute,
        second: lhs.second + rhs.second,
        nanoOfSecond: lhs.nano + rhs.nano,
        clock: lhs.clock
    )
}
public func += (lhs: inout ZonedDateTime, rhs: Period) {
    lhs.year += rhs.year
    lhs.month += rhs.month
    lhs.day += rhs.day
    lhs.hour += rhs.hour
    lhs.minute += rhs.minute
    lhs.second += rhs.second
    lhs.nano += rhs.nano
}
public func - (lhs: ZonedDateTime, rhs: Period) -> ZonedDateTime {
    return ZonedDateTime(
        year: lhs.year - rhs.year,
        month: lhs.month - rhs.month,
        day: lhs.day - rhs.day,
        hour: lhs.hour - rhs.hour,
        minute: lhs.minute - rhs.minute,
        second: lhs.second - rhs.second,
        nanoOfSecond: lhs.nano - rhs.nano,
        clock: lhs.clock
    )
}
public func -= (lhs: inout ZonedDateTime, rhs: Period) {
    lhs.year -= rhs.year
    lhs.month -= rhs.month
    lhs.day -= rhs.day
    lhs.hour -= rhs.hour
    lhs.minute -= rhs.minute
    lhs.second -= rhs.second
    lhs.nano -= rhs.nano
}