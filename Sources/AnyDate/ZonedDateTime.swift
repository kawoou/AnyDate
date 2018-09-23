import Foundation

public struct ZonedDateTime {
    
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
    ///
    /// If the input text and date format are mismatched, returns nil.
    ///
    /// - Parameters:
    ///     - text: The text to parse.
    ///     - clock: The Clock instance.
    /// - Returns: The parsed zoned date-time.
    public static func parse(_ text: String, clock: Clock = Clock.current) -> ZonedDateTime? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        guard let date = formatter.date(from: text) else { return nil }
        return ZonedDateTime(date, clock: clock)
    }

    /// Obtains an instance of ZonedDateTime from a text string such as '2007-12-03T10:15:30.217Z'.
    ///
    /// If the input text and date format are mismatched, returns nil.
    ///
    /// - Parameters:
    ///     - text: The text to parse.
    ///     - timeZone: The TimeZone instance.
    /// - Returns: The parsed zoned date-time.
    public static func parse(_ text: String, timeZone: TimeZone) -> ZonedDateTime? {
        return ZonedDateTime.parse(text, clock: Clock(timeZone))
    }
    
    /// Obtains an instance of ZonedDateTime from a text string using a specific formatter.
    ///
    /// If the input text and date format are mismatched, returns nil.
    ///
    /// - Parameters:
    ///     - text: The text to parse.
    ///     - formatter: The formatter to parse.
    ///     - clock: The Clock instance.
    /// - Returns: The parsed zoned date-time.
    public static func parse(_ text: String, formatter: DateFormatter, clock: Clock = Clock.current) -> ZonedDateTime? {
        guard let date = formatter.date(from: text) else { return nil }
        return ZonedDateTime(date, clock: clock)
    }

    /// Obtains an instance of ZonedDateTime from a text string using a specific formatter.
    ///
    /// If the input text and date format are mismatched, returns nil.
    ///
    /// - Parameters:
    ///     - text: The text to parse.
    ///     - formatter: The formatter to parse.
    ///     - timeZone: The TimeZone instance.
    /// - Returns: The parsed zoned date-time.
    public static func parse(_ text: String, formatter: DateFormatter, timeZone: TimeZone) -> ZonedDateTime? {
        return ZonedDateTime.parse(text, formatter: formatter, clock: Clock(timeZone))
    }
    
    
    // MARK: - Property
    
    /// Gets the Clock part of this date-time.
    public var clock: Clock { return self.internalClock }

    /// Gets the TimeZone part of this date-time.
    public var timeZone: TimeZone { return self.internalClock.toTimeZone() }
    
    /// Gets the LocalDateTime part of this date-time.
    public fileprivate(set) var localDateTime: LocalDateTime {
        get { return self.internalDateTime }
        set { self.internalDateTime = newValue }
    }
    
    /// Gets the LocalDate part of this date-time.
    public var localDate: LocalDate {
        return self.internalDateTime.date
    }
    
    /// Gets the LocalTime part of this date-time.
    public var localTime: LocalTime {
        return self.internalDateTime.time
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
    
    fileprivate var internalClock: Clock = Clock.current
    
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
    ///
    /// - Parameters clock: The time zone information.
    public func toDate(clock: Clock?) -> Date {
        return self.toDate(timeZone: clock?.toTimeZone())
    }

    /// Returns an instance of Date.
    ///
    /// - Parameters timeZone: The time zone information.
    public func toDate(timeZone: TimeZone? = nil) -> Date {
        /// Specify date components
        var dateComponents = DateComponents()
        dateComponents.timeZone = self.internalClock.toTimeZone()
        dateComponents.year = self.internalDateTime.year
        dateComponents.month = self.internalDateTime.month
        dateComponents.day = self.internalDateTime.day
        dateComponents.hour = self.internalDateTime.hour
        dateComponents.minute = self.internalDateTime.minute
        dateComponents.second = self.internalDateTime.second
        dateComponents.nanosecond = self.internalDateTime.nano
        
        /// Create date from components
        var calendar = Calendar.current
        calendar.timeZone = timeZone ?? self.internalClock.toTimeZone()
        
        return calendar.date(from: dateComponents)!
    }

    /// Returns a copy of this date-time with a different time-zone,
    /// retaining the local date-time if possible.
    ///
    /// - Parameters zoneSameLocal: the time-zone to change to.
    /// - Returns: A ZonedDateTime based on this date-time with the requested zone.
    public func with(zoneSameLocal clock: Clock) -> ZonedDateTime {
        var dateTime = ZonedDateTime(self)
        
        let oldValue = self.internalClock
        let offset = clock.offsetSecond - oldValue.offsetSecond
        
        dateTime.internalDateTime.second += offset
        dateTime.internalClock = clock
        
        return dateTime
    }

    /// Returns a copy of this date-time with a different time-zone,
    /// retaining the local date-time if possible.
    ///
    /// - Parameters zoneSameLocal: the time-zone to change to.
    /// - Returns: A ZonedDateTime based on this date-time with the requested zone.
    public func with(zoneSameLocal timeZone: TimeZone) -> ZonedDateTime {
        return self.with(zoneSameLocal: Clock(timeZone))
    }

    /// Returns a copy of this date-time with a different time-zone,
    /// retaining the instant.
    ///
    /// - Parameters zoneSameLocal: the time-zone to change to.
    /// - Returns: A ZonedDateTime based on this date-time with the requested zone.
    public func with(zoneSameInstant clock: Clock) -> ZonedDateTime {
        var dateTime = ZonedDateTime(self)
        dateTime.internalClock = clock
        
        return dateTime
    }

    /// Returns a copy of this date-time with a different time-zone,
    /// retaining the instant.
    ///
    /// - Parameters zoneSameLocal: the time-zone to change to.
    /// - Returns: A ZonedDateTime based on this date-time with the requested zone.
    public func with(zoneSameInstant timeZone: TimeZone) -> ZonedDateTime {
        return self.with(zoneSameInstant: Clock(timeZone))
    }
    
    /// Returns a copy of this ZonedDateTime with the year value altered.
    ///
    /// - Parameters year: The new value of the year field in the result.
    /// - Returns: An ZonedDateTime based on this with the specified field set.
    public func with(year: Int) -> ZonedDateTime {
        return ZonedDateTime(
            year: year,
            month: self.internalDateTime.month,
            day: self.internalDateTime.day,
            hour: self.internalDateTime.hour,
            minute: self.internalDateTime.minute,
            second: self.internalDateTime.second,
            nanoOfSecond: self.internalDateTime.nano,
            clock: self.internalClock
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the month-of-year value altered.
    ///
    /// - Parameters month: The new value of the month field in the result.
    /// - Returns: An ZonedDateTime based on this with the specified field set.
    public func with(month: Int) -> ZonedDateTime {
        return ZonedDateTime(
            year: self.internalDateTime.year,
            month: month,
            day: self.internalDateTime.day,
            hour: self.internalDateTime.hour,
            minute: self.internalDateTime.minute,
            second: self.internalDateTime.second,
            nanoOfSecond: self.internalDateTime.nano,
            clock: self.internalClock
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the day-of-month value altered.
    ///
    /// - Parameters day: The new value of the day field in the result.
    /// - Returns: An ZonedDateTime based on this with the specified field set.
    public func with(day: Int) -> ZonedDateTime {
        return ZonedDateTime(
            year: self.internalDateTime.year,
            month: self.internalDateTime.month,
            day: day,
            hour: self.internalDateTime.hour,
            minute: self.internalDateTime.minute,
            second: self.internalDateTime.second,
            nanoOfSecond: self.internalDateTime.nano,
            clock: self.internalClock
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the hour-of-day value altered.
    ///
    /// - Parameters hour: The new value of the hour field in the result.
    /// - Returns: An ZonedDateTime based on this with the specified field set.
    public func with(hour: Int) -> ZonedDateTime {
        return ZonedDateTime(
            year: self.internalDateTime.year,
            month: self.internalDateTime.month,
            day: self.internalDateTime.day,
            hour: hour,
            minute: self.internalDateTime.minute,
            second: self.internalDateTime.second,
            nanoOfSecond: self.internalDateTime.nano,
            clock: self.internalClock
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the minute-of-hour value altered.
    ///
    /// - Parameters minute: The new value of the minute field in the result.
    /// - Returns: An ZonedDateTime based on this with the specified field set.
    public func with(minute: Int) -> ZonedDateTime {
        return ZonedDateTime(
            year: self.internalDateTime.year,
            month: self.internalDateTime.month,
            day: self.internalDateTime.day,
            hour: self.internalDateTime.hour,
            minute: minute,
            second: self.internalDateTime.second,
            nanoOfSecond: self.internalDateTime.nano,
            clock: self.internalClock
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the second-of-minute value altered.
    ///
    /// - Parameters second: The new value of the second field in the result.
    /// - Returns: An ZonedDateTime based on this with the specified field set.
    public func with(second: Int) -> ZonedDateTime {
        return ZonedDateTime(
            year: self.internalDateTime.year,
            month: self.internalDateTime.month,
            day: self.internalDateTime.day,
            hour: self.internalDateTime.hour,
            minute: self.internalDateTime.minute,
            second: second,
            nanoOfSecond: self.internalDateTime.nano,
            clock: self.internalClock
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the nano-of-second value altered.
    ///
    /// - Parameters nano: The new value of the nano field in the result.
    /// - Returns: An ZonedDateTime based on this with the specified field set.
    public func with(nano: Int) -> ZonedDateTime {
        return ZonedDateTime(
            year: self.internalDateTime.year,
            month: self.internalDateTime.month,
            day: self.internalDateTime.day,
            hour: self.internalDateTime.hour,
            minute: self.internalDateTime.minute,
            second: self.internalDateTime.second,
            nanoOfSecond: nano,
            clock: self.internalClock
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the specified amount added.
    ///
    /// - Parameters:
    ///     - component: The unit of the amount to add.
    ///     - newValue: The amount of the unit to add to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount added.
    public func plus(component: LocalDateTime.PlusComponent, newValue: Int) -> ZonedDateTime {
        return ZonedDateTime(
            self.internalDateTime.plus(component: component, newValue: newValue),
            clock: self.internalClock
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in years added.
    ///
    /// - Parameters year: The amount of the year field to add to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount added.
    public func plus(year: Int) -> ZonedDateTime {
        return self.plus(component: .year, newValue: year)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in months added.
    ///
    /// - Parameters month: The amount of the month field to add to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount added.
    public func plus(month: Int) -> ZonedDateTime {
        return self.plus(component: .month, newValue: month)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in weeks added.
    ///
    /// - Parameters week: The amount of the weelk field to add to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount added.
    public func plus(week: Int) -> ZonedDateTime {
        return self.plus(component: .weekday, newValue: week)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in days added.
    ///
    /// - Parameters day: The amount of the day field to add to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount added.
    public func plus(day: Int) -> ZonedDateTime {
        return self.plus(component: .day, newValue: day)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in hours added.
    ///
    /// - Parameters hour: The amount of the hour field to add to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount added.
    public func plus(hour: Int) -> ZonedDateTime {
        return self.plus(component: .hour, newValue: hour)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in minutes added.
    ///
    /// - Parameters minute: The amount of the minute field to add to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount added.
    public func plus(minute: Int) -> ZonedDateTime {
        return self.plus(component: .minute, newValue: minute)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in seconds added.
    ///
    /// - Parameters second: The amount of the second field to add to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount added.
    public func plus(second: Int) -> ZonedDateTime {
        return self.plus(component: .second, newValue: second)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in nanoseconds added.
    ///
    /// - Parameters nano: The amount of the nanosecond field to add to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount added.
    public func plus(nano: Int) -> ZonedDateTime {
        return self.plus(component: .nanosecond, newValue: nano)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified amount subtracted.
    ///
    /// - Parameters:
    ///     - component: The unit of the amount to subtract.
    ///     - newValue: The amount of the unit to subtract to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount subtracted.
    public func minus(component: LocalDateTime.PlusComponent, newValue: Int) -> ZonedDateTime {
        return ZonedDateTime(
            self.internalDateTime.minus(component: component, newValue: newValue),
            clock: self.internalClock
        )
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in years subtracted.
    ///
    /// - Parameters year: The amount of the year field to subtract to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount subtracted.
    public func minus(year: Int) -> ZonedDateTime {
        return self.minus(component: .year, newValue: year)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in months subtracted.
    ///
    /// - Parameters month: The amount of the month field to subtract to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount subtracted.
    public func minus(month: Int) -> ZonedDateTime {
        return self.minus(component: .month, newValue: month)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in weeks subtracted.
    ///
    /// - Parameters week: The amount of the week field to subtract to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount subtracted.
    public func minus(week: Int) -> ZonedDateTime {
        return self.minus(component: .weekday, newValue: week)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in days subtracted.
    ///
    /// - Parameters day: The amount of the day field to subtract to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount subtracted.
    public func minus(day: Int) -> ZonedDateTime {
        return self.minus(component: .day, newValue: day)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in hours subtracted.
    ///
    /// - Parameters hour: The amount of the hour field to subtract to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount subtracted.
    public func minus(hour: Int) -> ZonedDateTime {
        return self.minus(component: .hour, newValue: hour)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in minutes subtracted.
    ///
    /// - Parameters minute: The amount of the minute field to subtract to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount subtracted.
    public func minus(minute: Int) -> ZonedDateTime {
        return self.minus(component: .minute, newValue: minute)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in seconds subtracted.
    ///
    /// - Parameters second: The amount of the second field to subtract to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount subtracted.
    public func minus(second: Int) -> ZonedDateTime {
        return self.minus(component: .second, newValue: second)
    }
    
    /// Returns a copy of this ZonedDateTime with the specified period in nanoseconds subtracted.
    ///
    /// - Parameters nano: The amount of the nanosecond field to subtract to the result.
    /// - Results: An ZonedDateTime based on this date-time with the specified amount subtracted.
    public func minus(nano: Int) -> ZonedDateTime {
        return self.minus(component: .nanosecond, newValue: nano)
    }
    
    /// Gets the range of valid values for the specified field.
    ///
    /// - Parameters component: The field to query the range for.
    /// - Returns: The range of valid values for the field.
    public func range(_ component: LocalDateTime.RangeComponent) -> (Int, Int) {
        return self.internalDateTime.range(component)
    }
    
    /// Calculates the period between this ZonedDateTime and another ZonedDateTime as a Period.
    ///
    /// - Parameters:
    ///     - endDateTime: The end date-time, exclusive, which is converted to an ZonedDateTime.
    /// - Returns: The Period of time between this date-time and the end date-time.
    public func until(endDateTime: ZonedDateTime) -> Period {
        let timeZoneAmount = endDateTime.internalClock.offsetSecond - self.internalClock.offsetSecond
    
        var period = self.internalDateTime.until(endDateTime: endDateTime.internalDateTime)
        period.second += timeZoneAmount
    
        return period
    }

    /// Calculates the amount of time until another ZonedDateTime in terms of the specified unit.
    ///
    /// - Parameters:
    ///     - endDateTime: The end date-time, exclusive, which is converted to an ZonedDateTime.
    ///     - component: The unit to measure the amount in.
    /// - Returns: The amount of time between this date-time and the end date-time.
    public func until(endDateTime: ZonedDateTime, component: LocalDateTime.UntilComponent) -> Int64 {
        let timeZoneAmount = endDateTime.internalClock.offsetSecond - self.internalClock.offsetSecond
        
        var newDateTime = LocalDateTime(endDateTime.internalDateTime)
        newDateTime.second += timeZoneAmount
        
        return self.internalDateTime.until(endDateTime: newDateTime, component: component)
    }
    
    /// Formats this time using the specified formatter.
    ///
    /// - Parameters formatter: The formatter to use.
    /// - Returns: The formatted date string.
    public func format(_ formatter: DateFormatter) -> String {
        let formatter = formatter
        formatter.timeZone = self.internalClock.toTimeZone()
        return formatter.string(from: self.toDate())
    }
    
    
    // MARK: - Operator
    
    /// ZonedDateTime
    static public func + (lhs: ZonedDateTime, rhs: ZonedDateTime) -> ZonedDateTime {
        let timeZoneAmount = rhs.internalClock.offsetSecond - lhs.internalClock.offsetSecond
        
        return ZonedDateTime(
            (lhs.localDateTime + rhs.localDateTime).plus(second: timeZoneAmount),
            clock: lhs.internalClock
        )
    }
    static public func += (lhs: inout ZonedDateTime, rhs: ZonedDateTime) {
        let timeZoneAmount = rhs.internalClock.offsetSecond - lhs.internalClock.offsetSecond
        
        lhs.localDateTime += rhs.localDateTime
        lhs.second += timeZoneAmount
    }
    static public func - (lhs: ZonedDateTime, rhs: ZonedDateTime) -> ZonedDateTime {
        let timeZoneAmount = rhs.internalClock.offsetSecond - lhs.internalClock.offsetSecond
        
        return ZonedDateTime(
            (lhs.localDateTime - rhs.localDateTime).minus(second: timeZoneAmount),
            clock: lhs.internalClock
        )
    }
    static public func -= (lhs: inout ZonedDateTime, rhs: ZonedDateTime) {
        let timeZoneAmount = rhs.internalClock.offsetSecond - lhs.internalClock.offsetSecond
        
        lhs.localDateTime -= rhs.localDateTime
        lhs.second -= timeZoneAmount
    }
    
    /// LocalDateTime
    static public func + (lhs: ZonedDateTime, rhs: LocalDateTime) -> ZonedDateTime {
        return ZonedDateTime(
            (lhs.localDateTime + rhs),
            clock: lhs.internalClock
        )
    }
    static public func += (lhs: inout ZonedDateTime, rhs: LocalDateTime) {
        lhs.localDateTime += rhs
    }
    static public func - (lhs: ZonedDateTime, rhs: LocalDateTime) -> ZonedDateTime {
        return ZonedDateTime(
            (lhs.localDateTime - rhs),
            clock: lhs.internalClock
        )
    }
    static public func -= (lhs: inout ZonedDateTime, rhs: LocalDateTime) {
        lhs.localDateTime -= rhs
    }
    
    /// LocalDate
    static public func + (lhs: ZonedDateTime, rhs: LocalDate) -> ZonedDateTime {
        return ZonedDateTime(
            (lhs.localDateTime + rhs),
            clock: lhs.internalClock
        )
    }
    static public func += (lhs: inout ZonedDateTime, rhs: LocalDate) {
        lhs.localDateTime += rhs
    }
    static public func - (lhs: ZonedDateTime, rhs: LocalDate) -> ZonedDateTime {
        return ZonedDateTime(
            (lhs.localDateTime - rhs),
            clock: lhs.internalClock
        )
    }
    static public func -= (lhs: inout ZonedDateTime, rhs: LocalDate) {
        lhs.localDateTime -= rhs
    }
    
    /// LocalTime
    static public func + (lhs: ZonedDateTime, rhs: LocalTime) -> ZonedDateTime {
        return ZonedDateTime(
            (lhs.localDateTime + rhs),
            clock: lhs.internalClock
        )
    }
    static public func += (lhs: inout ZonedDateTime, rhs: LocalTime) {
        lhs.localDateTime += rhs
    }
    static public func - (lhs: ZonedDateTime, rhs: LocalTime) -> ZonedDateTime {
        return ZonedDateTime(
            (lhs.localDateTime - rhs),
            clock: lhs.internalClock
        )
    }
    static public func -= (lhs: inout ZonedDateTime, rhs: LocalTime) {
        lhs.localDateTime -= rhs
    }
    
    
    // MARK: - Lifecycle
    
    /// Creates the current date-time from the time-zone.
    public init(clock: Clock = Clock.current) {
        let date = Date()
        self.internalDateTime = LocalDateTime(date, clock: clock)
    }

    /// Creates the current date-time from the time-zone.
    public init(timeZone: TimeZone) {
        self.init(clock: Clock(timeZone))
    }
    
    /// Creates a ZonedDateTime from an instance of Date.
    public init(_ date: Date, clock: Clock = Clock.current) {
        self.internalClock = clock
        self.internalDateTime = LocalDateTime(date, clock: clock)
    }

    /// Creates a ZonedDateTime from an instance of Date.
    public init(_ date: Date, timeZone: TimeZone) {
        self.init(date, clock: Clock(timeZone))
    }
    
    /// Copies an instance of ZonedDateTime.
    public init(_ dateTime: ZonedDateTime) {
        self.internalClock = dateTime.internalClock
        self.internalDateTime = LocalDateTime(dateTime.internalDateTime)
    }
    
    /// Creates an instance of ZonedDateTime from an instance of LocalDateTime.
    public init(_ dateTime: LocalDateTime, clock: Clock = Clock.current) {
        self.internalClock = clock
        self.internalDateTime = LocalDateTime(dateTime)
    }

    /// Creates an instance of ZonedDateTime from an instance of LocalDateTime.
    public init(_ dateTime: LocalDateTime, timeZone: TimeZone) {
        self.init(dateTime, clock: Clock(timeZone))
    }
    
    /// Returns a copy of this date-time with the new date and time, checking
    /// to see if a new object is in fact required.
    public init(date: LocalDate, time: LocalTime, clock: Clock = Clock.current) {
        self.internalClock = clock
        self.internalDateTime = LocalDateTime(date: date, time: time)
    }

    /// Returns a copy of this date-time with the new date and time, checking
    /// to see if a new object is in fact required.
    public init(date: LocalDate, time: LocalTime, timeZone: TimeZone) {
        self.init(date: date, time: time, clock: Clock(timeZone))
    }
    
    /// Creates an instance of ZonedDateTime from year, month,
    /// day, hour, minute, second and nanosecond.
    public init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, nanoOfSecond: Int, clock: Clock = Clock.current) {
        self.internalClock = clock
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

    /// Creates an instance of ZonedDateTime from year, month,
    /// day, hour, minute, second and nanosecond.
    public init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, nanoOfSecond: Int, timeZone: TimeZone) {
        self.init(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            nanoOfSecond: nanoOfSecond,
            clock: Clock(timeZone)
        )
    }
    
    /// Creates an instance of ZonedDateTime using seconds from the
    /// epoch of 1970-01-01T00:00:00Z.
    public init(epochDay: Int64, nanoOfDay: Int64, clock: Clock = Clock.current) {
        self.internalClock = clock
        self.internalDateTime = LocalDateTime(epochDay: epochDay, nanoOfDay: nanoOfDay)
    }

    /// Creates an instance of ZonedDateTime using seconds from the
    /// epoch of 1970-01-01T00:00:00Z.
    public init(epochDay: Int64, nanoOfDay: Int64, timeZone: TimeZone) {
        self.init(epochDay: epochDay, nanoOfDay: nanoOfDay, clock: Clock(timeZone))
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
extension ZonedDateTime: Hashable {
    
#if swift(>=4.2)
    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// Implement this method to conform to the `Hashable` protocol. The
    /// components used for hashing must be the same as the components compared
    /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
    /// with each of these components.
    ///
    /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
    ///   compile-time error in the future.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(internalClock)
        hasher.combine(internalDateTime)
    }
#else
    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    public var hashValue: Int {
        return internalClock.hashValue ^ (79 &* internalDateTime.hashValue)
    }
#endif
}
extension ZonedDateTime: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    public static func ==(lhs: ZonedDateTime, rhs: ZonedDateTime) -> Bool {
        return lhs.internalClock == rhs.internalClock && lhs.internalDateTime == rhs.internalDateTime
    }
    
}
extension ZonedDateTime: CustomStringConvertible, CustomDebugStringConvertible {
    
    /// A textual representation of this instance.
    public var description: String {
        return "\(self.internalDateTime.description)(\(self.internalClock.description))"
    }
    
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return description
    }
    
}
extension ZonedDateTime: CustomReflectable {

    /// The custom mirror for this instance.
    ///
    /// If this type has value semantics, the mirror should be unaffected by
    /// subsequent mutations of the instance.
    public var customMirror: Mirror {
        var c = [(label: String?, value: Any)]()
        c.append((label: "year", value: self.year))
        c.append((label: "month", value: self.month))
        c.append((label: "day", value: self.day))
        c.append((label: "hour", value: self.hour))
        c.append((label: "minute", value: self.minute))
        c.append((label: "second", value: self.second))
        c.append((label: "nano", value: self.nano))
        c.append((label: "clock", value: self.clock.description))
        return Mirror(self, children: c, displayStyle: Mirror.DisplayStyle.struct)
    }

}
#if swift(>=4.1) || (swift(>=3.3) && !swift(>=4.0))
extension ZonedDateTime: CustomPlaygroundDisplayConvertible {
    
    /// Returns the custom playground description for this instance.
    ///
    /// If this type has value semantics, the instance returned should be
    /// unaffected by subsequent mutations if possible.
    public var playgroundDescription: Any {
        return self.description
    }
    
}
#else
extension ZonedDateTime: CustomPlaygroundQuickLookable {

    /// A custom playground Quick Look for this instance.
    ///
    /// If this type has value semantics, the `PlaygroundQuickLook` instance
    /// should be unaffected by subsequent mutations.
    public var customPlaygroundQuickLook: PlaygroundQuickLook {
        return .text(self.description)
    }
}
#endif

#if swift(>=3.2)
extension ZonedDateTime: Codable {

    /// A type that can be used as a key for encoding and decoding.
    ///
    /// - datetime: The LocalDateTime.
    /// - clock: The Clock.
    private enum CodingKeys: Int, CodingKey {
        case datetime
        case clock
    }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.internalDateTime = try container.decode(LocalDateTime.self, forKey: .datetime)
        self.internalClock = try container.decode(Clock.self, forKey: .clock)
    }

    /// Encodes this value into the given encoder.
    ///
    /// If the value fails to encode anything, `encoder` will encode an empty
    /// keyed container in its place.
    ///
    /// This function throws an error if any values are invalid for the given
    /// encoder's format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.internalDateTime, forKey: .datetime)
        try container.encode(self.internalClock, forKey: .clock)
    }
}
#endif
