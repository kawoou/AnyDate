import Foundation

public struct LocalDateTime {
    
    // MARK: - Enumerable
    
    public enum Component: String {
        case year
        case month
        case day
        case hour
        case minute
        case second
        case nanosecond
    }
    public enum PlusComponent: String {
        case year
        case month
        case weekday
        case day
        case hour
        case minute
        case second
        case nanosecond
    }
    public enum RangeComponent: String {
        case era
        case year
        case month
        case weekday
        case weekOfMonth
        case hour
        case minute
        case second
        case nanosecond
    }
    public enum UntilComponent: String {
        case year
        case month
        case weekday
        case day
        case hour
        case minute
        case second
        case nanosecond
    }
    
    
    // MARK: - Static
    
    /// The minimum supported LocalDateTime, '-999999999-01-01T00:00:00'.
    static public var min: LocalDateTime {
        return LocalDateTime(date: LocalDate.min, time: LocalTime.min)
    }
    
    /// The maximum supported LocalDateTime, '+999999999-12-31T23:59:59.999999999'.
    static public var max: LocalDateTime {
        return LocalDateTime(date: LocalDate.max, time: LocalTime.max)
    }
    
    /// Obtains an instance of LocalDateTime from a text string such as '2007-12-03T10:15:30.217'.
    ///
    /// If the input text and date format are mismatched, returns nil.
    ///
    /// - Parameters:
    ///     - text: The text to parse.
    ///     - clock: The Clock instance.
    /// - Returns: The parsed local date-time.
    static public func parse(_ text: String, clock: Clock) -> LocalDateTime? {
        return LocalDateTime.parse(text, timeZone: clock.toTimeZone())
    }

    /// Obtains an instance of LocalDateTime from a text string such as '2007-12-03T10:15:30.217'.
    ///
    /// If the input text and date format are mismatched, returns nil.
    ///
    /// - Parameters:
    ///     - text: The text to parse.
    ///     - timeZone: The TimeZone instance.
    /// - Returns: The parsed local date-time.
    static public func parse(_ text: String, timeZone: TimeZone = TimeZone.current) -> LocalDateTime? {
        /// ISO8601 format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return LocalDateTime.parse(text, formatter: formatter, timeZone: timeZone)
    }
    
    /// Obtains an instance of LocalDateTime from a text string using a specific formatter.
    ///
    /// If the input text and date format are mismatched, returns nil.
    ///
    /// - Parameters:
    ///     - text: The text to parse.
    ///     - formatter: The formatter to parse.
    ///     - clock: The Clock instance.
    /// - Returns: The parsed local date-time.
    static public func parse(_ text: String, formatter: DateFormatter, clock: Clock) -> LocalDateTime? {
        return LocalDateTime.parse(text, formatter: formatter, timeZone: clock.toTimeZone())
    }

    /// Obtains an instance of LocalDateTime from a text string using a specific formatter.
    ///
    /// If the input text and date format are mismatched, returns nil.
    ///
    /// - Parameters:
    ///     - text: The text to parse.
    ///     - formatter: The formatter to parse.
    ///     - timeZone: The TimeZone instance.
    /// - Returns: The parsed local date-time.
    static public func parse(_ text: String, formatter: DateFormatter, timeZone: TimeZone = TimeZone.current) -> LocalDateTime? {
        formatter.timeZone = timeZone

        guard let date = formatter.date(from: text) else { return nil }
        return LocalDateTime(date)
    }
    
    
    // MARK: - Property
    
    /// The date part.
    public var date: LocalDate {
        get { return self.internalDate }
        set { self.internalDate = newValue; self.normalize() }
    }
    
    /// The time part.
    public var time: LocalTime {
        get { return self.internalTime }
        set { self.internalTime = newValue; self.normalize() }
    }
    
    /// Gets the year field.
    public var year: Int {
        get { return self.internalDate.year }
        set { self.internalDate.year = newValue; self.normalize() }
    }
    
    /// Gets the month-of-year field from 1 to 12.
    public var month: Int {
        get { return self.internalDate.month }
        set { self.internalDate.month = newValue; self.normalize() }
    }
    
    /// Gets the day-of-month field.
    public var day: Int {
        get { return self.internalDate.day }
        set { self.internalDate.day = newValue; self.normalize() }
    }
    
    /// Gets the day-of-week field.
    public var dayOfWeek: Int { return self.internalDate.dayOfWeek }
    
    /// Gets the hour-of-day field.
    public var hour: Int {
        get { return self.internalTime.hour }
        set { self.internalTime.hour = newValue; self.normalize() }
    }
    
    /// Gets the minute-of-hour field.
    public var minute: Int {
        get { return self.internalTime.minute }
        set { self.internalTime.minute = newValue; self.normalize() }
    }
    
    /// Gets the second-of-minute field.
    public var second: Int {
        get { return self.internalTime.second }
        set { self.internalTime.second = newValue; self.normalize() }
    }
    
    /// Gets the nano-of-second field.
    public var nano: Int {
        get { return self.internalTime.nano }
        set { self.internalTime.nano = newValue; self.normalize() }
    }
    
    
    // MARK: - Private
    
    fileprivate var internalDate: LocalDate
    fileprivate var internalTime: LocalTime
    
    fileprivate mutating func normalize() {
        if self.internalTime.hour >= LocalTime.Constant.hoursPerDay {
            self.internalDate.day += (self.internalTime.hour / LocalTime.Constant.hoursPerDay)
            self.internalTime.hour %= LocalTime.Constant.hoursPerDay
        }
    }
    
    
    // MARK: - Public
    
    /// Returns the length of the month represented by this date.
    public func lengthOfMonth() -> Int {
        return self.internalDate.lengthOfMonth()
    }
    
    /// Returns the length of the year represented by this date.
    public func lengthOfYear() -> Int {
        return self.internalDate.lengthOfYear()
    }
    
    /// Checks if the year is a leap year, according to the ISO proleptic
    /// calendar system rules.
    public func isLeapYear() -> Bool {
        return self.internalDate.isLeapYear()
    }
    
    /// Returns an instance of Date.
    ///
    /// - Parameters clock: The time zone information.
    public func toDate(clock: Clock) -> Date {
        return self.toDate(timeZone: clock.toTimeZone())
    }

    /// Returns an instance of Date.
    ///
    /// - Parameters timeZone: The time zone information.
    public func toDate(timeZone: TimeZone = TimeZone.current) -> Date {
        /// Specify date components
        var dateComponents = DateComponents()
        dateComponents.timeZone = timeZone
        dateComponents.year = self.internalDate.year
        dateComponents.month = self.internalDate.month
        dateComponents.day = self.internalDate.day
        dateComponents.hour = self.internalTime.hour
        dateComponents.minute = self.internalTime.minute
        dateComponents.second = self.internalTime.second
        dateComponents.nanosecond = self.internalTime.nano
        
        /// Create date from components
        var calendar = Calendar.current
        calendar.timeZone = timeZone

        return calendar.date(from: dateComponents)!
    }
    
    /// Returns a copy of this date-time with the specified field set to a new value.
    ///
    /// - Parameters:
    ///     - component: The field to set in the result.
    ///     - newValue: The new value of the field in the result.
    /// - Returns: An LocalDateTime based on this with the specified field set.
    public func with(component: Component, newValue: Int) -> LocalDateTime {
        switch component {
        case .hour, .minute, .second, .nanosecond:
            return LocalDateTime(
                date: self.internalDate,
                time: self.internalTime.with(
                    component: LocalTime.Component(rawValue: component.rawValue)!,
                    newValue: newValue
                )
            )
            
        default:
            return LocalDateTime(
                date: self.internalDate.with(
                    component: LocalDate.Component(rawValue: component.rawValue)!,
                    newValue: newValue
                ),
                time: self.internalTime
            )
        }
    }
    
    /// Returns a copy of this LocalDateTime with the year altered.
    ///
    /// - Parameters year: The new value of the year field in the result.
    /// - Returns: An LocalDateTime based on this with the specified field set.
    public func with(year: Int) -> LocalDateTime {
        return self.with(component: .year, newValue: year)
    }
    
    /// Returns a copy of this LocalDateTime with the month-of-year altered.
    ///
    /// - Parameters month: The new value of the month field in the result.
    /// - Returns: An LocalDateTime based on this with the specified field set.
    public func with(month: Int) -> LocalDateTime {
        return self.with(component: .month, newValue: month)
    }
    
    /// Returns a copy of this LocalDateTime with the day-of-month altered.
    ///
    /// - Parameters day: The new value of the day field in the result.
    /// - Returns: An LocalDateTime based on this with the specified field set.
    public func with(day: Int) -> LocalDateTime {
        return self.with(component: .day, newValue: day)
    }
    
    /// Returns a copy of this LocalDateTime with the hour-of-day value altered.
    ///
    /// - Parameters hour: The new value of the hour field in the result.
    /// - Returns: An LocalDateTime based on this with the specified field set.
    public func with(hour: Int) -> LocalDateTime {
        return self.with(component: .hour, newValue: hour)
    }
    
    /// Returns a copy of this LocalDateTime with the minute-of-hour value altered.
    ///
    /// - Parameters minute: The new value of the minute field in the result.
    /// - Returns: An LocalDateTime based on this with the specified field set.
    public func with(minute: Int) -> LocalDateTime {
        return self.with(component: .minute, newValue: minute)
    }
    
    /// Returns a copy of this LocalDateTime with the second-of-minute value altered.
    ///
    /// - Parameters second: The new value of the second field in the result.
    /// - Returns: An LocalDateTime based on this with the specified field set.
    public func with(second: Int) -> LocalDateTime {
        return self.with(component: .second, newValue: second)
    }
    
    /// Returns a copy of this LocalDateTime with the nano-of-second value altered.
    ///
    /// - Parameters nano: The new value of the nano-of-second field in the result.
    /// - Returns: An LocalDateTime based on this with the specified field set.
    public func with(nano: Int) -> LocalDateTime {
        return self.with(component: .nanosecond, newValue: nano)
    }
    
    /// Returns a copy of this date-time with the specified amount added.
    ///
    /// - Parameters:
    ///     - component: The unit of the amount to add.
    ///     - newValue: The amount of the unit to add to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount added.
    public func plus(component: PlusComponent, newValue: Int) -> LocalDateTime {
        switch component {
        case .hour, .minute, .second, .nanosecond:
            return LocalDateTime(
                date: self.internalDate,
                time: self.internalTime.plus(
                    component: LocalTime.PlusComponent(rawValue: component.rawValue)!,
                    newValue: newValue
                )
            )
            
        default:
            return LocalDateTime(
                date: self.internalDate.plus(
                    component: LocalDate.PlusComponent(rawValue: component.rawValue)!,
                    newValue: newValue
                ),
                time: self.internalTime
            )
        }
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in years added.
    ///
    /// - Parameters year: The amount of the year field to add to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount added.
    public func plus(year: Int) -> LocalDateTime {
        return self.plus(component: .year, newValue: year)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in months added.
    ///
    /// - Parameters month: The amount of the month field to add to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount added.
    public func plus(month: Int) -> LocalDateTime {
        return self.plus(component: .month, newValue: month)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in weeks added.
    ///
    /// - Parameters week: The amount of the week field to add to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount added.
    public func plus(week: Int) -> LocalDateTime {
        return self.plus(component: .weekday, newValue: week)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in days added.
    ///
    /// - Parameters day: The amount of the day field to add to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount added.
    public func plus(day: Int) -> LocalDateTime {
        return self.plus(component: .day, newValue: day)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in hours added.
    ///
    /// - Parameters hour: The amount of the hour field to add to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount added.
    public func plus(hour: Int) -> LocalDateTime {
        return self.plus(component: .hour, newValue: hour)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in minutes added.
    ///
    /// - Parameters minute: The amount of the minute field to add to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount added.
    public func plus(minute: Int) -> LocalDateTime {
        return self.plus(component: .minute, newValue: minute)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in seconds added.
    ///
    /// - Parameters second: The amount of the second field to add to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount added.
    public func plus(second: Int) -> LocalDateTime {
        return self.plus(component: .second, newValue: second)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in nanoseconds added.
    ///
    /// - Parameters nano: The amount of the nanosecond field to add to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount added.
    public func plus(nano: Int) -> LocalDateTime {
        return self.plus(component: .nanosecond, newValue: nano)
    }
    
    /// Returns a copy of this date-time with the specified amount subtracted.
    ///
    /// - Parameters:
    ///     - component: The unit of the amount to subtract.
    ///     - newValue: The amount of the unit to subtract to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount subtracted.
    public func minus(component: PlusComponent, newValue: Int) -> LocalDateTime {
        switch component {
        case .hour, .minute, .second, .nanosecond:
            return LocalDateTime(
                date: self.internalDate,
                time: self.internalTime.minus(
                    component: LocalTime.PlusComponent(rawValue: component.rawValue)!,
                    newValue: newValue
                )
            )
            
        default:
            return LocalDateTime(
                date: self.internalDate.minus(
                    component: LocalDate.PlusComponent(rawValue: component.rawValue)!,
                    newValue: newValue
                ),
                time: self.internalTime
            )
        }
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in years subtracted.
    ///
    /// - Parameters year: The amount of the year field to subtract to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount subtracted.
    public func minus(year: Int) -> LocalDateTime {
        return self.minus(component: .year, newValue: year)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in months subtracted.
    ///
    /// - Parameters month: The amount of the month field to subtract to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount subtracted.
    public func minus(month: Int) -> LocalDateTime {
        return self.minus(component: .month, newValue: month)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in weeks subtracted.
    ///
    /// - Parameters week: The amount of the week field to subtract to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount subtracted.
    public func minus(week: Int) -> LocalDateTime {
        return self.minus(component: .weekday, newValue: week)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in days subtracted.
    ///
    /// - Parameters day: The amount of the day field to subtract to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount subtracted.
    public func minus(day: Int) -> LocalDateTime {
        return self.minus(component: .day, newValue: day)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in hours subtracted.
    ///
    /// - Parameters hour: The amount of the hour field to subtract to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount subtracted.
    public func minus(hour: Int) -> LocalDateTime {
        return self.minus(component: .hour, newValue: hour)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in minutes subtracted.
    ///
    /// - Parameters minute: The amount of the minute field to subtract to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount subtracted.
    public func minus(minute: Int) -> LocalDateTime {
        return self.minus(component: .minute, newValue: minute)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in seconds subtracted.
    ///
    /// - Parameters second: The amount of the second field to subtract to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount subtracted.
    public func minus(second: Int) -> LocalDateTime {
        return self.minus(component: .second, newValue: second)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in nanoseconds subtracted.
    ///
    /// - Parameters nano: The amount of the nanosecond field to subtract to the result.
    /// - Results: An LocalDateTime based on this date-time with the specified amount subtracted.
    public func minus(nano: Int) -> LocalDateTime {
        return self.minus(component: .nanosecond, newValue: nano)
    }
    
    /// Gets the range of valid values for the specified field.
    ///
    /// - Parameters component: The field to query the range for.
    /// - Returns: The range of valid values for the field.
    public func range(_ component: RangeComponent) -> (Int, Int) {
        switch component {
        case .hour, .minute, .second, .nanosecond:
            return self.internalTime.range(LocalTime.RangeComponent(rawValue: component.rawValue)!)
            
        default:
            return self.internalDate.range(LocalDate.RangeComponent(rawValue: component.rawValue)!)
        }
    }

    /// Calculates the period between this date-time and another date-time as a Period.
    ///
    /// - Parameters:
    ///     - endDateTime: The end date-time, exclusive, which is converted to an LocalDateTime.
    /// - Returns: The Period of time between this date-time and the end date-time.
    public func until(endDateTime: LocalDateTime) -> Period {
        let datePeriod = self.internalDate.until(endDate: endDateTime.internalDate)
        let timePeriod = self.internalTime.until(endTime: endDateTime.internalTime)
    
        return Period(
            year: datePeriod.year + timePeriod.year,
            month: datePeriod.month + timePeriod.month,
            day: datePeriod.day + timePeriod.day,
            hour: datePeriod.hour + timePeriod.hour,
            minute: datePeriod.minute + timePeriod.minute,
            second: datePeriod.second + timePeriod.second,
            nano: datePeriod.nano + timePeriod.nano
        )
    }
    
    /// Calculates the amount of time until another date-time in terms of the specified unit.
    ///
    /// - Parameters:
    ///     - endDateTime: The end date-time, exclusive, which is converted to an LocalDateTime.
    ///     - component: The unit to measure the amount in.
    /// - Returns: The amount of time between this date-time and the end date-time.
    public func until(endDateTime: LocalDateTime, component: UntilComponent) -> Int64 {
        switch component {
        case .nanosecond, .second, .minute, .hour:
            let timePart = self.internalTime.until(
                endTime: endDateTime.internalTime,
                component: LocalTime.UntilComponent(rawValue: component.rawValue)!
            )
            
            var amount = self.internalDate.until(endDate: endDateTime.internalDate, component: .day)
            guard amount != 0 else { return timePart }

            switch component {
            case .nanosecond:
                amount = amount * LocalTime.Constant.nanosPerDay
                
            case .second:
                amount = amount * Int64(LocalTime.Constant.secondsPerDay)
                
            case .minute:
                amount = amount * Int64(LocalTime.Constant.minutesPerDay)
                
            default:
                amount = amount * Int64(LocalTime.Constant.hoursPerDay)
            }
            return amount + timePart
            
        default:
            var endDate = endDateTime.internalDate
            if endDate < self.internalDate && endDateTime.internalTime < self.internalTime {
                endDate = endDate.minus(day: 1)
            } else if endDate > self.internalDate && endDateTime.internalTime > self.internalTime {
                endDate = endDate.plus(day: 1)
            }
            return self.internalDate.until(
                endDate: endDate,
                component: LocalDate.UntilComponent(rawValue: component.rawValue)!
            )
        }
    }
    
    /// Formats this date-time using the specified formatter.
    ///
    /// - Parameters formatter: The formatter to use.
    /// - Returns: The formatted date string.
    public func format(_ formatter: DateFormatter) -> String {
        return formatter.string(from: self.toDate())
    }
    
    
    // MARK: - Operator
    
    /// LocalDateTime
    static public func + (lhs: LocalDateTime, rhs: LocalDateTime) -> LocalDateTime {
        return LocalDateTime(
            date: lhs.internalDate + rhs.internalDate,
            time: lhs.internalTime + rhs.internalTime
        )
    }
    static public func += (lhs: inout LocalDateTime, rhs: LocalDateTime) {
        lhs.internalDate += rhs.internalDate
        lhs.internalTime += rhs.internalTime
    }
    static public func - (lhs: LocalDateTime, rhs: LocalDateTime) -> LocalDateTime {
        return LocalDateTime(
            date: lhs.internalDate - rhs.internalDate,
            time: lhs.internalTime - rhs.internalTime
        )
    }
    static public func -= (lhs: inout LocalDateTime, rhs: LocalDateTime) {
        lhs.internalDate -= rhs.internalDate
        lhs.internalTime -= rhs.internalTime
    }
    
    /// LocalDate
    static public func + (lhs: LocalDateTime, rhs: LocalDate) -> LocalDateTime {
        return LocalDateTime(
            date: lhs.internalDate + rhs,
            time: lhs.internalTime
        )
    }
    static public func += (lhs: inout LocalDateTime, rhs: LocalDate) {
        lhs.internalDate += rhs
    }
    static public func - (lhs: LocalDateTime, rhs: LocalDate) -> LocalDateTime {
        return LocalDateTime(
            date: lhs.internalDate - rhs,
            time: lhs.internalTime
        )
    }
    static public func -= (lhs: inout LocalDateTime, rhs: LocalDate) {
        lhs.internalDate -= rhs
    }
    
    /// LocalTime
    static public func + (lhs: LocalDateTime, rhs: LocalTime) -> LocalDateTime {
        return LocalDateTime(
            date: lhs.internalDate,
            time: lhs.internalTime + rhs
        )
    }
    static public func += (lhs: inout LocalDateTime, rhs: LocalTime) {
        lhs.internalTime += rhs
    }
    static public func - (lhs: LocalDateTime, rhs: LocalTime) -> LocalDateTime {
        return LocalDateTime(
            date: lhs.internalDate,
            time: lhs.internalTime - rhs
        )
    }
    static public func -= (lhs: inout LocalDateTime, rhs: LocalTime) {
        lhs.internalTime -= rhs
    }
    
    
    // MARK: - Lifecycle
    
    /// Creates the current date-time from the time-zone.
    public init(clock: Clock) {
        self.init(timeZone: clock.toTimeZone())
    }

    /// Creates the current date-time from the time-zone.
    public init(timeZone: TimeZone = TimeZone.current) {
        let now = Date()
        
        self.internalDate = LocalDate(now, timeZone: timeZone)
        self.internalTime = LocalTime(now, timeZone: timeZone)
        self.normalize()
    }
    
    /// Creates a local date-time from an instance of Date.
    public init(_ date: Date, clock: Clock) {
        self.init(date, timeZone: clock.toTimeZone())
    }

    /// Creates a local date-time from an instance of Date.
    public init(_ date: Date, timeZone: TimeZone = TimeZone.current) {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        self.internalDate = LocalDate(
            year: calendar.component(.year, from: date),
            month: calendar.component(.month, from: date),
            day: calendar.component(.day, from: date)
        )
        self.internalTime = LocalTime(
            hour: calendar.component(.hour, from: date),
            minute: calendar.component(.minute, from: date),
            second: calendar.component(.second, from: date),
            nanoOfSecond: calendar.component(.nanosecond, from: date)
        )
        self.normalize()
    }
    
    /// Copies an instance of LocalDateTime.
    public init(_ date: LocalDateTime) {
        self.internalDate = LocalDate(date.date)
        self.internalTime = LocalTime(date.time)
        self.normalize()
    }
    
    /// Returns a copy of this date-time with the new date and time, checking
    /// to see if a new object is in fact required.
    public init(date: LocalDate, time: LocalTime) {
        self.internalDate = LocalDate(date)
        self.internalTime = LocalTime(time)
        self.normalize()
    }
    
    /// Creates an instance of LocalDateTime from year, month,
    /// day, hour, minute, second and nanosecond.
    public init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int = 0, nanoOfSecond: Int = 0) {
        self.internalDate = LocalDate(year: year, month: month, day: day)
        self.internalTime = LocalTime(hour: hour, minute: minute, second: second, nanoOfSecond: nanoOfSecond)
        self.normalize()
    }
    
    /// Creates an instance of LocalDateTime using seconds from the
    /// epoch of 1970-01-01T00:00:00Z.
    public init(epochDay: Int64, nanoOfDay: Int64) {
        self.internalDate = LocalDate(epochDay: epochDay)
        self.internalTime = LocalTime(nanoOfDay: nanoOfDay)
        self.normalize()
    }
    
}

extension LocalDateTime: Comparable {
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    public static func <(lhs: LocalDateTime, rhs: LocalDateTime) -> Bool {
        guard lhs.internalDate == rhs.internalDate else { return lhs.internalDate < rhs.internalDate }
        return lhs.internalTime < rhs.internalTime
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than that of the second argument.
    public static func >(lhs: LocalDateTime, rhs: LocalDateTime) -> Bool {
        guard lhs.internalDate == rhs.internalDate else { return lhs.internalDate > rhs.internalDate }
        return lhs.internalTime > rhs.internalTime
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than or equal to that of the second argument.
    public static func <=(lhs: LocalDateTime, rhs: LocalDateTime) -> Bool {
        return !(lhs > rhs)
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than or equal to that of the second argument.
    public static func >=(lhs: LocalDateTime, rhs: LocalDateTime) -> Bool {
        return !(lhs < rhs)
    }
    
}
extension LocalDateTime: Hashable {
    
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
        hasher.combine(internalDate)
        hasher.combine(internalTime)
    }
#else
    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    public var hashValue: Int {
        return internalDate.hashValue ^ (13 &* internalTime.hashValue)
    }
#endif
}
extension LocalDateTime: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    public static func ==(lhs: LocalDateTime, rhs: LocalDateTime) -> Bool {
        return lhs.internalDate == rhs.internalDate && lhs.internalTime == rhs.internalTime
    }
    
}
extension LocalDateTime: CustomStringConvertible, CustomDebugStringConvertible {
    
    /// A textual representation of this instance.
    public var description: String {
        return self.internalDate.description + "T" + self.internalTime.description
    }
    
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return self.internalDate.debugDescription + "T" + self.internalTime.debugDescription
    }
    
}
extension LocalDateTime: CustomReflectable {

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
        c.append((label: "nano", value: Int(self.nano)))
        return Mirror(self, children: c, displayStyle: Mirror.DisplayStyle.struct)
    }

}
#if swift(>=4.1) || (swift(>=3.3) && !swift(>=4.0))
extension LocalDateTime: CustomPlaygroundDisplayConvertible {
    
    /// Returns the custom playground description for this instance.
    ///
    /// If this type has value semantics, the instance returned should be
    /// unaffected by subsequent mutations if possible.
    public var playgroundDescription: Any {
        return self.description
    }
    
}
#else
extension LocalDateTime: CustomPlaygroundQuickLookable {

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
extension LocalDateTime: Codable {

    /// A type that can be used as a key for encoding and decoding.
    ///
    /// - date: The LocalDate.
    /// - time: The LocalTime.
    private enum CodingKeys: Int, CodingKey {
        case date
        case time
    }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.internalDate = try container.decode(LocalDate.self, forKey: .date)
        self.internalTime = try container.decode(LocalTime.self, forKey: .time)
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
        try container.encode(self.internalDate, forKey: .date)
        try container.encode(self.internalTime, forKey: .time)
    }
}
#endif
