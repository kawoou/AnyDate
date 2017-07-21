import Foundation

final public class ZonedDateTime {
    
    // MARK: - Static
    
    /// The minimum supported ZonedDateTime from the system clock in the default time-zone, '-999999999-01-01T00:00:00'.
    public static var min: ZonedDateTime {
        return ZonedDateTime(LocalDateTime.min)
    }
    
    /// The maximum supported ZonedDateTime from the system clock in the default time-zone, '+999999999-12-31T23:59:59.999999999'.
    public static var max: ZonedDateTime {
        return ZonedDateTime(LocalDateTime.max)
    }
    
    /// Obtains an instance of ZonedDateTime from a text string such as '2007-12-03T10:15:30.217Z'.
    public static func parse(_ text: String, timeZone: TimeZone = TimeZone.current) -> ZonedDateTime? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        guard let date = formatter.date(from: text) else { return nil }
        return ZonedDateTime(date, timeZone: timeZone)
    }
    
    /// Obtains an instance of ZonedDateTime from a text string using a specific formatter.
    public static func parse(_ text: String, formatter: DateFormatter, timeZone: TimeZone = TimeZone.current) -> ZonedDateTime? {
        guard let date = formatter.date(from: text) else { return nil }
        return ZonedDateTime(date, timeZone: timeZone)
    }
    
    
    // MARK: - Property
    
    /// Gets the TimeZone part of this date-time.
    public var timeZone: TimeZone { return self.internalTimeZone }
    
    /// Gets the LocalDateTime part of this date-time.
    public fileprivate(set) var localDateTime: LocalDateTime {
        get { return self.internalDateTime }
        set { self.internalDateTime = newValue }
    }
    
    /// Gets the LocalDate part of this date-time.
    public fileprivate(set) var localDate: LocalDate {
        get { return self.internalDateTime.date }
        set { self.internalDateTime.date = newValue }
    }
    
    /// Gets the LocalTime part of this date-time.
    public fileprivate(set) var localTime: LocalTime {
        get { return self.internalDateTime.time }
        set { self.internalDateTime.time = newValue }
    }
    
    /// Gets the year field.
    public var year: Int {
        get { return self.internalDateTime.year }
        set { self.internalDateTime.year = newValue }
    }
    
    /// Gets the month-of-year field from 1 to 12.
    public var month: Int {
        get { return self.internalDateTime.month }
        set { self.internalDateTime.month = newValue }
    }
    
    /// Gets the day-of-month field.
    public var day: Int {
        get { return self.internalDateTime.day }
        set { self.internalDateTime.day = newValue }
    }
    
    /// Gets the day-of-week field.
    public var dayOfWeek: Int { return self.internalDateTime.dayOfWeek }
    
    /// Gets the hour-of-day field.
    public var hour: Int {
        get { return self.internalDateTime.hour }
        set { self.internalDateTime.hour = newValue }
    }
    
    /// Gets the minute-of-hour field.
    public var minute: Int {
        get { return self.internalDateTime.minute }
        set { self.internalDateTime.minute = newValue }
    }
    
    /// Gets the second-of-minute field.
    public var second: Int {
        get { return self.internalDateTime.second }
        set { self.internalDateTime.second = newValue }
    }
    
    /// Gets the nano-of-second field.
    public var nano: Int {
        get { return self.internalDateTime.nano }
        set { self.internalDateTime.nano = newValue }
    }
    
    
    // MARK: - Private
    
    fileprivate var internalTimeZone: TimeZone = TimeZone.current
    
    fileprivate var internalDateTime: LocalDateTime
    
    
    // MARK: - Public
    
    /// Returns the length of the month represented by this date.
    public func lengthOfMonth() -> Int {
        return self.internalDateTime.lengthOfMonth()
    }
    
    /// Returns the length of the year represented by this date.
    public func lengthOfYear() -> Int {
        return self.internalDateTime.lengthOfYear()
    }
    
    /// Checks if the year is a leap year, according to the ISO proleptic
    /// calendar system rules.
    public func isLeapYear() -> Bool {
        return self.internalDateTime.isLeapYear()
    }
    
    /// Returns an instance of Date.
    public func toDate(timeZone: TimeZone? = nil) -> Date {
        /// Specify date components
        var dateComponents = DateComponents()
        dateComponents.timeZone = self.internalTimeZone
        dateComponents.year = self.internalDateTime.year
        dateComponents.month = self.internalDateTime.month
        dateComponents.day = self.internalDateTime.day
        dateComponents.hour = self.internalDateTime.hour
        dateComponents.minute = self.internalDateTime.minute
        dateComponents.second = self.internalDateTime.second
        dateComponents.nanosecond = self.internalDateTime.nano
        
        /// Create date from components
        var calendar = Calendar.current
        calendar.timeZone = timeZone ?? self.internalTimeZone
        
        let date = calendar.date(from: dateComponents)
        assert(date != nil, "Failed to convert Date from LocalTime.")
        
        return date!
    }
    
    /// Returns a copy of this date-time with a different time-zone,
    /// retaining the local date-time if possible.
    public func with(zoneSameLocal timeZone: TimeZone) -> ZonedDateTime {
        let dateTime = ZonedDateTime(self)
        
        let oldValue = self.internalTimeZone
        let offset = timeZone.secondsFromGMT() - oldValue.secondsFromGMT()
        
        dateTime.internalDateTime.second += offset
        dateTime.internalTimeZone = timeZone
        
        return dateTime
    }
    
    /// Returns a copy of this date-time with a different time-zone,
    /// retaining the instant.
    public func with(zoneSameInstant timeZone: TimeZone) -> ZonedDateTime {
        let dateTime = ZonedDateTime(self)
        dateTime.internalTimeZone = timeZone
        
        return dateTime
    }
    
    /// Returns a copy of this ZonedDateTime with the year value altered.
    public func with(year: Int) -> ZonedDateTime {
        return ZonedDateTime(
            year: year,
            month: self.internalDateTime.month,
            day: self.internalDateTime.day,
            hour: self.internalDateTime.hour,
            minute: self.internalDateTime.minute,
            second: self.internalDateTime.second,
            nanoOfSecond: self.internalDateTime.nano,
            timeZone: self.internalTimeZone
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the month-of-year value altered.
    public func with(month: Int) -> ZonedDateTime {
        return ZonedDateTime(
            year: self.internalDateTime.year,
            month: month,
            day: self.internalDateTime.day,
            hour: self.internalDateTime.hour,
            minute: self.internalDateTime.minute,
            second: self.internalDateTime.second,
            nanoOfSecond: self.internalDateTime.nano,
            timeZone: self.internalTimeZone
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the day-of-month value altered.
    public func with(day: Int) -> ZonedDateTime {
        return ZonedDateTime(
            year: self.internalDateTime.year,
            month: self.internalDateTime.month,
            day: day,
            hour: self.internalDateTime.hour,
            minute: self.internalDateTime.minute,
            second: self.internalDateTime.second,
            nanoOfSecond: self.internalDateTime.nano,
            timeZone: self.internalTimeZone
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the hour-of-day value altered.
    public func with(hour: Int) -> ZonedDateTime {
        return ZonedDateTime(
            year: self.internalDateTime.year,
            month: self.internalDateTime.month,
            day: self.internalDateTime.day,
            hour: hour,
            minute: self.internalDateTime.minute,
            second: self.internalDateTime.second,
            nanoOfSecond: self.internalDateTime.nano,
            timeZone: self.internalTimeZone
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the minute-of-hour value altered.
    public func with(minute: Int) -> ZonedDateTime {
        return ZonedDateTime(
            year: self.internalDateTime.year,
            month: self.internalDateTime.month,
            day: self.internalDateTime.day,
            hour: self.internalDateTime.hour,
            minute: minute,
            second: self.internalDateTime.second,
            nanoOfSecond: self.internalDateTime.nano,
            timeZone: self.internalTimeZone
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the second-of-minute value altered.
    public func with(second: Int) -> ZonedDateTime {
        return ZonedDateTime(
            year: self.internalDateTime.year,
            month: self.internalDateTime.month,
            day: self.internalDateTime.day,
            hour: self.internalDateTime.hour,
            minute: self.internalDateTime.minute,
            second: second,
            nanoOfSecond: self.internalDateTime.nano,
            timeZone: self.internalTimeZone
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the nano-of-second value altered.
    public func with(nano: Int) -> ZonedDateTime {
        return ZonedDateTime(
            year: self.internalDateTime.year,
            month: self.internalDateTime.month,
            day: self.internalDateTime.day,
            hour: self.internalDateTime.hour,
            minute: self.internalDateTime.minute,
            second: self.internalDateTime.second,
            nanoOfSecond: nano,
            timeZone: self.internalTimeZone
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the specified amount added.
    public func plus(component: Calendar.Component, newValue: Int) -> ZonedDateTime {
        return ZonedDateTime(
            self.internalDateTime.plus(component: component, newValue: newValue),
            timeZone: timeZone
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in years added.
    public func plus(year: Int) -> ZonedDateTime {
        return self.plus(component: .year, newValue: year)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in months added.
    public func plus(month: Int) -> ZonedDateTime {
        return self.plus(component: .month, newValue: month)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in weeks added.
    public func plus(week: Int) -> ZonedDateTime {
        return self.plus(component: .weekday, newValue: week)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in days added.
    public func plus(day: Int) -> ZonedDateTime {
        return self.plus(component: .day, newValue: day)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in hours added.
    public func plus(hour: Int) -> ZonedDateTime {
        return self.plus(component: .hour, newValue: hour)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in minutes added.
    public func plus(minute: Int) -> ZonedDateTime {
        return self.plus(component: .minute, newValue: minute)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in seconds added.
    public func plus(second: Int) -> ZonedDateTime {
        return self.plus(component: .second, newValue: second)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in nanoseconds added.
    public func plus(nano: Int) -> ZonedDateTime {
        return self.plus(component: .nanosecond, newValue: nano)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified amount subtracted.
    public func minus(component: Calendar.Component, newValue: Int) -> ZonedDateTime {
        return ZonedDateTime(
            self.internalDateTime.minus(component: component, newValue: newValue),
            timeZone: timeZone
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in years subtracted.
    public func minus(year: Int) -> ZonedDateTime {
        return self.minus(component: .year, newValue: year)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in months subtracted.
    public func minus(month: Int) -> ZonedDateTime {
        return self.minus(component: .month, newValue: month)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in weeks subtracted.
    public func minus(week: Int) -> ZonedDateTime {
        return self.minus(component: .weekday, newValue: week)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in days subtracted.
    public func minus(day: Int) -> ZonedDateTime {
        return self.minus(component: .day, newValue: day)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in hours subtracted.
    public func minus(hour: Int) -> ZonedDateTime {
        return self.minus(component: .hour, newValue: hour)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in minutes subtracted.
    public func minus(minute: Int) -> ZonedDateTime {
        return self.minus(component: .minute, newValue: minute)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in seconds subtracted.
    public func minus(second: Int) -> ZonedDateTime {
        return self.minus(component: .second, newValue: second)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in nanoseconds subtracted.
    public func minus(nano: Int) -> ZonedDateTime {
        return self.minus(component: .nanosecond, newValue: nano)
    }
    
    /// Gets the range of valid values for the specified field.
    public func range(_ component: Calendar.Component) -> (Int, Int) {
        return self.internalDateTime.range(component)
    }
    
    /// Calculates the amount of time until another ZonedDateTime in terms of the specified unit.
    public func until(endDateTime: ZonedDateTime, component: Calendar.Component) -> Int64 {
        let timeZoneAmount = endDateTime.internalTimeZone.secondsFromGMT() - self.internalTimeZone.secondsFromGMT()
        
        let newDateTime = LocalDateTime(endDateTime.internalDateTime)
        newDateTime.second += timeZoneAmount
        
        return self.internalDateTime.until(endDateTime: newDateTime, component: component)
    }
    
    /// Formats this time using the specified formatter.
    public func format(_ formatter: DateFormatter) -> String {
        let date = self.toDate()
        
        let formatter = formatter
        formatter.timeZone = self.internalTimeZone
        return formatter.string(from: date)
    }
    
    
    // MARK: - Lifecycle
    
    /// Creates the current date-time from the system clock in the default time-zone.
    public init() {
        let date = Date()
        
        self.internalDateTime = LocalDateTime(date)
    }
    
    /// Creates a ZonedDateTime from an instance of Date.
    public init(_ date: Date, timeZone: TimeZone = TimeZone.current) {
        self.internalTimeZone = timeZone
        self.internalDateTime = LocalDateTime(date, timeZone: timeZone)
    }
    
    /// Copies an instance of ZonedDateTime.
    public init(_ dateTime: ZonedDateTime) {
        self.internalTimeZone = dateTime.internalTimeZone
        self.internalDateTime = LocalDateTime(dateTime.internalDateTime)
    }
    
    /// Creates an instance of ZonedDateTime from an instance of LocalDateTime.
    public init(_ dateTime: LocalDateTime, timeZone: TimeZone = TimeZone.current) {
        self.internalTimeZone = timeZone
        self.internalDateTime = LocalDateTime(dateTime)
    }
    
    /// Returns a copy of this date-time with the new date and time, checking
    /// to see if a new object is in fact required.
    public init(date: LocalDate, time: LocalTime, timeZone: TimeZone = TimeZone.current) {
        self.internalTimeZone = timeZone
        self.internalDateTime = LocalDateTime(date: date, time: time)
    }
    
    /// Creates an instance of ZonedDateTime from year, month,
    /// day, hour, minute, second and nanosecond.
    public init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, nanoOfSecond: Int, timeZone: TimeZone = TimeZone.current) {
        self.internalTimeZone = timeZone
        self.internalDateTime = LocalDateTime(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            nanoOfSecond: nanoOfSecond
        )
    }
    
    /// Creates an instance of ZonedDateTime using seconds from the
    /// epoch of 1970-01-01T00:00:00Z.
    public init(epochDay: Int64, nanoOfDay: Int, timeZone: TimeZone = TimeZone.current) {
        self.internalTimeZone = timeZone
        self.internalDateTime = LocalDateTime(epochDay: epochDay, nanoOfDay: nanoOfDay)
    }
    
}

extension ZonedDateTime: Comparable {
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    public static func <(lhs: ZonedDateTime, rhs: ZonedDateTime) -> Bool {
        let second = lhs.until(endDateTime: rhs, component: .second)
        if second == 0 {
            return lhs.nano < rhs.nano
        }
        return 0 < second
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than that of the second argument.
    public static func >(lhs: ZonedDateTime, rhs: ZonedDateTime) -> Bool {
        let second = lhs.until(endDateTime: rhs, component: .second)
        if second == 0 {
            return lhs.nano > rhs.nano
        }
        return 0 > second
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than or equal to that of the second argument.
    public static func <=(lhs: ZonedDateTime, rhs: ZonedDateTime) -> Bool {
        return !(lhs > rhs)
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than or equal to that of the second argument.
    public static func >=(lhs: ZonedDateTime, rhs: ZonedDateTime) -> Bool {
        return !(lhs < rhs)
    }
    
}
extension ZonedDateTime: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    public static func ==(lhs: ZonedDateTime, rhs: ZonedDateTime) -> Bool {
        return lhs.internalTimeZone == rhs.internalTimeZone && lhs.internalDateTime == rhs.internalDateTime
    }
    
}
extension ZonedDateTime: CustomStringConvertible, CustomDebugStringConvertible {
    
    /// A textual representation of this instance.
    public var description: String {
        return self.internalDateTime.description + " " + self.internalTimeZone.identifier
    }
    
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return self.internalDateTime.debugDescription + " " + self.internalTimeZone.identifier
    }
    
}

// MARK: - Operator

public func + (lhs: ZonedDateTime, rhs: ZonedDateTime) -> ZonedDateTime {
    let timeZoneAmount = rhs.internalTimeZone.secondsFromGMT() - lhs.internalTimeZone.secondsFromGMT()
    
    return ZonedDateTime(
        (lhs.localDateTime + rhs.localDateTime).plus(second: timeZoneAmount),
        timeZone: lhs.internalTimeZone
    )
}
public func += (lhs: inout ZonedDateTime, rhs: ZonedDateTime) {
    let timeZoneAmount = rhs.internalTimeZone.secondsFromGMT() - lhs.internalTimeZone.secondsFromGMT()
    
    lhs.localDateTime += rhs.localDateTime
    lhs.second += timeZoneAmount
}
public func - (lhs: ZonedDateTime, rhs: ZonedDateTime) -> ZonedDateTime {
    let timeZoneAmount = rhs.internalTimeZone.secondsFromGMT() - lhs.internalTimeZone.secondsFromGMT()
    
    return ZonedDateTime(
        (lhs.localDateTime - rhs.localDateTime).minus(second: timeZoneAmount),
        timeZone: lhs.internalTimeZone
    )
}
public func -= (lhs: inout ZonedDateTime, rhs: ZonedDateTime) {
    let timeZoneAmount = rhs.internalTimeZone.secondsFromGMT() - lhs.internalTimeZone.secondsFromGMT()
    
    lhs.localDateTime -= rhs.localDateTime
    lhs.second -= timeZoneAmount
}

