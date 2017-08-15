import Foundation

public struct LocalTime {
    
    // MARK: - Constant
    
    internal struct Constant {
        
        /// The minimum supported nano second, '0'
        static public let minNano = Int64(0)
        
        /// The maximum supported nano second, '+999,999,999'
        static public let maxNano = Constant.nanosPerSecond - 1
        
        /// The minimum supported second, '0'
        static public let minSecond = 0
        
        /// The maximum supported second, '+59'
        static public let maxSecond = Constant.secondsPerMinute - 1
        
        /// The minimum supported minute, '0'
        static public let minMinute = 0
        
        /// The maximum supported minute, '+59'
        static public let maxMinute = Constant.minutesPerHour - 1
        
        /// The minimum supported hour, '0'
        static public let minHour = 0
        
        /// The maximum supported hour, '+23'
        static public let maxHour = Constant.hoursPerDay - 1
        
        /// Hours per day.
        static public let hoursPerDay = 24
        
        /// Minutes per hour.
        static public let minutesPerHour = 60
        
        /// Minutes per day.
        static public let minutesPerDay = Constant.minutesPerHour * Constant.hoursPerDay
        
        /// Seconds per minute.
        static public let secondsPerMinute = 60
        
        /// Seconds per hour.
        static public let secondsPerHour = Constant.secondsPerMinute * Constant.minutesPerHour
        
        /// Seconds per day.
        static public let secondsPerDay = Constant.secondsPerHour * Constant.hoursPerDay
        
        /// Milliseconds per day.
        static public let millisPerDay = Int64(Constant.secondsPerDay) * 1000
        
        /// Microseconds per day.
        static public let microsPerDay = Int64(Constant.secondsPerDay) * 1000_000
        
        /// Nanos per second.
        static public let nanosPerSecond = Int64(1000_000_000)
        
        /// Nanos per minute.
        static public let nanosPerMinute = Constant.nanosPerSecond * Int64(Constant.secondsPerMinute)
        
        /// Nanos per hour.
        static public let nanosPerHour = Constant.nanosPerMinute * Int64(Constant.minutesPerHour)
        
        /// Nanos per day.
        static public let nanosPerDay = Constant.nanosPerHour * Int64(Constant.hoursPerDay)
        
    }
    
    
    // MARK: - Enumerable
    
    public enum Component: String {
        case hour
        case minute
        case second
        case nanosecond
    }
    public enum PlusComponent: String {
        case hour
        case minute
        case second
        case nanosecond
    }
    public enum RangeComponent: String {
        case hour
        case minute
        case second
        case nanosecond
    }
    public enum UntilComponent: String {
        case day
        case hour
        case minute
        case second
        case nanosecond
    }
    
    
    // MARK: - Static
    
    /// The time of midnight at the start of the day, '00:00'.
    public static var midNight: LocalTime {
        return LocalTime(hour: 0, minute: 0, second: 0, nanoOfSecond: 0)
    }
    
    /// The time of noon in the middle of the day, '12:00'.
    public static var noon: LocalTime {
        return LocalTime(hour: 12, minute: 0, second: 0, nanoOfSecond: 0)
    }
    
    /// The minimum supported LocalTime, '00:00'.
    /// The maximum supported LocalTime, '23:59:59.999999999'.
    public static var min: LocalTime {
        return LocalTime(hour: 0, minute: 0, second: 0, nanoOfSecond: 0)
    }
    
    /// The maximum supported LocalTime, '23:59:59.999999999'.
    /// This is the time just before midnight at the end of the day.
    public static var max: LocalTime {
        return LocalTime(hour: Constant.maxHour, minute: Constant.maxMinute, second: Constant.maxSecond, nanoOfSecond: Int(Constant.maxNano))
    }
    
    /// Gets the local time of each hour.
    public static func hour(_ hour: Int) -> LocalTime {
        return LocalTime(hour: hour, minute: 0, second: 0, nanoOfSecond: 0)
    }
    
    /// Obtains an instance of LocalTime from a text string such as "10:15:00".
    /// If the input text and date format are mismatched, returns nil.
    public static func parse(_ text: String, clock: Clock) -> LocalTime? {
        return LocalTime.parse(text, timeZone: clock.toTimeZone())
    }
    public static func parse(_ text: String, timeZone: TimeZone = TimeZone.current) -> LocalTime? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return LocalTime.parse(text, formatter: formatter, timeZone: timeZone)
    }
    
    /// Obtains an instance of LocalTime from a text string using a specific formatter.
    /// If the input text and date format are mismatched, returns nil.
    public static func parse(_ text: String, formatter: DateFormatter, clock: Clock) -> LocalTime? {
        return LocalTime.parse(text, formatter: formatter, timeZone: clock.toTimeZone())
    }
    public static func parse(_ text: String, formatter: DateFormatter, timeZone: TimeZone = TimeZone.current) -> LocalTime? {
        formatter.timeZone = timeZone
        
        guard let date = formatter.date(from: text) else { return nil }
        return LocalTime(date)
    }
    
    
    // MARK: - Property
    
    /// Gets the hour-of-day field.
    public var hour: Int {
        get { return self.internalHour }
        set { self.internalHour = newValue; self.normalize() }
    }
    
    /// Gets the minute-of-hour field from 0 to 59.
    public var minute: Int {
        get { return self.internalMinute }
        set { self.internalMinute = newValue; self.normalize() }
    }
    
    /// Gets the second-of-minute field from 0 to 59.
    public var second: Int {
        get { return self.internalSecond }
        set { self.internalSecond = newValue; self.normalize() }
    }
    
    /// Gets the nano-of-second field from 0 to 999,999,999.
    public var nano: Int {
        get { return Int(self.internalNano) }
        set { self.internalNano = Int64(newValue); self.normalize() }
    }
    
    /// Gets the time as seconds of day,
    public var secondOfDay: Int {
        var total = self.internalHour * Constant.secondsPerHour
        total += self.internalMinute * Constant.secondsPerMinute
        total += self.internalSecond
        return total
    }
    
    /// Gets the time as nanos of day,
    public var nanoOfDay: Int64 {
        var total = Int64(self.internalHour) * Constant.nanosPerHour
        total += Int64(self.internalMinute) * Constant.nanosPerMinute
        total += Int64(self.internalSecond) * Constant.nanosPerSecond
        total += self.internalNano
        return total
    }
    
    
    // MARK: - Private
    
    fileprivate var internalHour: Int
    fileprivate var internalMinute: Int
    fileprivate var internalSecond: Int
    fileprivate var internalNano: Int64
    
    private func isValid() -> Bool {
        guard self.internalMinute >= Constant.minMinute else { return false }
        guard self.internalMinute <= Constant.maxMinute else { return false }
        guard self.internalSecond >= Constant.minSecond else { return false }
        guard self.internalSecond <= Constant.maxSecond else { return false }
        guard self.internalNano >= Constant.minNano else { return false }
        guard self.internalNano <= Constant.maxNano else { return false }
        return true
    }
    
    fileprivate mutating func normalize() {
        guard !self.isValid() else { return }

        var total = Int64(self.internalHour) * Constant.nanosPerHour
        total += Int64(self.internalMinute) * Constant.nanosPerMinute
        total += Int64(self.internalSecond) * Constant.nanosPerSecond
        total += self.internalNano

        self.internalNano = total % Constant.nanosPerSecond
        total /= Constant.nanosPerSecond

        self.internalSecond = Int(total % Int64(Constant.secondsPerMinute))
        total /= Int64(Constant.secondsPerMinute)

        self.internalMinute = Int(total % Int64(Constant.minutesPerHour))
        self.internalHour = Int(total / Int64(Constant.minutesPerHour))
    }
    
    
    
    // MARK: - Public
    
    /// Returns an instance of Date.
    public func toDate(clock: Clock) throws -> Date {
        return try self.toDate(timeZone: clock.toTimeZone())
    }
    public func toDate(timeZone: TimeZone = TimeZone.current) throws -> Date {
        /// Specify date components
        var dateComponents = DateComponents()
        dateComponents.timeZone = timeZone
        dateComponents.hour = self.internalHour
        dateComponents.minute = self.internalMinute
        dateComponents.second = self.internalSecond
        dateComponents.nanosecond = Int(self.internalNano)
        
        /// Create date from components
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        if let date = calendar.date(from: dateComponents) {
            return date
        } else {
            /// Failed to convert Date from LocalTime.
            throw ParseException.failedConversionToDate
        }
    }
    
    /// Returns a copy of this time with the specified field set to a new value.
    public func with(component: Component, newValue: Int) -> LocalTime {
        switch component {
        case .hour:
            return self.with(hour: newValue)
            
        case .minute:
            return self.with(minute: newValue)
            
        case .second:
            return self.with(second: newValue)
            
        case .nanosecond:
            return self.with(nano: newValue)
        }
    }
    
    /// Returns a copy of this LocalTime with the hour-of-day value altered.
    public func with(hour: Int) -> LocalTime {
        return LocalTime(hour: hour, minute: self.minute, second: self.second, nanoOfSecond: self.nano)
    }
    
    /// Returns a copy of this LocalTime with the minute-of-hour value altered.
    public func with(minute: Int) -> LocalTime {
        return LocalTime(hour: self.hour, minute: minute, second: self.second, nanoOfSecond: self.nano)
    }
    
    /// Returns a copy of this LocalTime with the second-of-minute value altered.
    public func with(second: Int) -> LocalTime {
        return LocalTime(hour: self.hour, minute: self.minute, second: second, nanoOfSecond: self.nano)
    }
    
    /// Returns a copy of this LocalTime with the nano-of-second value altered.
    public func with(nano: Int) -> LocalTime {
        return LocalTime(hour: self.hour, minute: self.minute, second: self.second, nanoOfSecond: nano)
    }
    
    /// Returns a copy of this time with the specified amount added.
    public func plus(component: PlusComponent, newValue: Int) -> LocalTime {
        switch component {
        case .hour:
            return self.plus(hour: newValue)
            
        case .minute:
            return self.plus(minute: newValue)
            
        case .second:
            return self.plus(second: newValue)
            
        case .nanosecond:
            return self.plus(nano: newValue)
        }
    }
    
    /// Returns a copy of this LocalTime with the specified period in hours added.
    public func plus(hour: Int) -> LocalTime {
        return LocalTime(hour: self.hour + hour, minute: self.minute, second: self.second, nanoOfSecond: self.nano)
    }
    
    /// Returns a copy of this LocalTime with the specified period in minutes added.
    public func plus(minute: Int) -> LocalTime {
        return LocalTime(hour: self.hour, minute: self.minute + minute, second: self.second, nanoOfSecond: self.nano)
    }
    
    /// Returns a copy of this LocalTime with the specified period in seconds added.
    public func plus(second: Int) -> LocalTime {
        return LocalTime(hour: self.hour, minute: self.minute, second: self.second + second, nanoOfSecond: self.nano)
    }
    
    /// Returns a copy of this LocalTime with the specified period in nanoseconds added.
    public func plus(nano: Int) -> LocalTime {
        return LocalTime(hour: self.hour, minute: self.minute, second: self.second, nanoOfSecond: self.nano + nano)
    }
    
    /// Returns a copy of this time with the specified amount subtracted.
    public func minus(component: PlusComponent, newValue: Int) -> LocalTime {
        return self.plus(component: component, newValue: -newValue)
    }
    
    /// Returns a copy of this LocalTime with the specified period in hours subtracted.
    public func minus(hour: Int) -> LocalTime {
        return self.plus(hour: -hour)
    }
    
    /// Returns a copy of this LocalTime with the specified period in minutes subtracted.
    public func minus(minute: Int) -> LocalTime {
        return self.plus(minute: -minute)
    }
    
    /// Returns a copy of this LocalTime with the specified period in seconds subtracted.
    public func minus(second: Int) -> LocalTime {
        return self.plus(second: -second)
    }
    
    /// Returns a copy of this LocalTime with the specified period in nanoseconds subtracted.
    public func minus(nano: Int) -> LocalTime {
        return self.plus(nano: -nano)
    }
    
    /// Gets the range of valid values for the specified field.
    public func range(_ component: RangeComponent) -> (Int, Int) {
        switch component {
        case .nanosecond:
            return (Int(Constant.minNano), Int(Constant.maxNano))
            
        case .second:
            return (Constant.minSecond, Constant.maxSecond)
            
        case .minute:
            return (Constant.minMinute, Constant.maxMinute)
            
        case .hour:
            return (Constant.minHour, Constant.maxHour)
        }
    }
    
    /// Calculates the period between this time and another time as a Period.
    public func until(endTime: LocalTime) -> Period {
        var nanosUntil = endTime.nanoOfDay - self.nanoOfDay
    
        let nano = nanosUntil % Constant.nanosPerSecond
        nanosUntil /= Constant.nanosPerSecond
    
        let second = Int(nanosUntil % Int64(Constant.secondsPerMinute))
        nanosUntil /= Int64(Constant.secondsPerMinute)
    
        let hour = Int(nanosUntil / Int64(Constant.minutesPerHour))
        let minute = Int(nanosUntil % Int64(Constant.minutesPerHour))
    
        return Period(year: 0, month: 0, day: 0, hour: hour, minute: minute, second: second, nano: Int(nano))
    }

    /// Calculates the amount of time until another time in terms of the specified unit.
    public func until(endTime: LocalTime, component: UntilComponent) -> Int64 {
        let nanosUntil = endTime.nanoOfDay - self.nanoOfDay
        switch component {
        case .nanosecond:
            return nanosUntil
            
        case .second:
            return nanosUntil / Constant.nanosPerSecond
            
        case .minute:
            return nanosUntil / Constant.nanosPerMinute
            
        case .hour:
            return nanosUntil / Constant.nanosPerHour
            
        case .day:
            return nanosUntil / Constant.nanosPerDay
        }
    }
    
    /// Formats this time using the specified formatter.
    public func format(_ formatter: DateFormatter) -> String {
        if let date = try? self.toDate() {
            return formatter.string(from: date)
        } else {
            return ""
        }
    }
    
    
    // MARK: - Lifecycle
    
    /// Creates the current time from the system clock in the default time-zone.
    public init(clock: Clock) {
        self.init(timeZone: clock.toTimeZone())
    }
    public init(timeZone: TimeZone = TimeZone.current) {
        let now = Date()
        
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        self.internalHour = calendar.component(.hour, from: now)
        self.internalMinute = calendar.component(.minute, from: now)
        self.internalSecond = calendar.component(.second, from: now)
        self.internalNano = Int64(calendar.component(.nanosecond, from: now))
        self.normalize()
    }
    
    /// Creates a local time from an instance of Date.
    public init(_ date: Date, clock: Clock) {
        self.init(date, timeZone: clock.toTimeZone())
    }
    public init(_ date: Date, timeZone: TimeZone = TimeZone.current) {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        self.internalHour = calendar.component(.hour, from: date)
        self.internalMinute = calendar.component(.minute, from: date)
        self.internalSecond = calendar.component(.second, from: date)
        self.internalNano = Int64(calendar.component(.nanosecond, from: date))
        self.normalize()
    }
    
    /// Copies an instance of LocalTime.
    public init(_ time: LocalTime) {
        self.internalHour = time.hour
        self.internalMinute = time.minute
        self.internalSecond = time.second
        self.internalNano = Int64(time.nano)
        self.normalize()
    }
    
    /// Creates an instance of LocalTime from an hour, minute, second and nanosecond.
    public init(hour: Int, minute: Int, second: Int = 0, nanoOfSecond: Int = 0) {
        self.internalHour = hour
        self.internalMinute = minute
        self.internalSecond = second
        self.internalNano = Int64(nanoOfSecond)
        self.normalize()
    }
    
    /// Creates an instance of LocalTime from a second-of-day value.
    public init(secondOfDay: Int) {
        self.internalHour = 0
        self.internalMinute = 0
        self.internalSecond = secondOfDay
        self.internalNano = 0
        self.normalize()
    }
    
    /// Creates an instance of LocalTime from a nanos-of-day value.
    public init(nanoOfDay: Int64) {
        self.internalHour = 0
        self.internalMinute = 0
        self.internalSecond = 0
        self.internalNano = nanoOfDay
        self.normalize()
    }
    
}

extension LocalTime: Comparable {
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    public static func <(lhs: LocalTime, rhs: LocalTime) -> Bool {
        if lhs.hour < rhs.hour { return true }
        if lhs.minute < rhs.minute { return true }
        if lhs.second < rhs.second { return true }
        if lhs.nano < rhs.nano { return true }
        return false
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than that of the second argument.
    public static func >(lhs: LocalTime, rhs: LocalTime) -> Bool {
        if lhs.hour > rhs.hour { return true }
        if lhs.minute > rhs.minute { return true }
        if lhs.second > rhs.second { return true }
        if lhs.nano > rhs.nano { return true }
        return false
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than or equal to that of the second argument.
    public static func <=(lhs: LocalTime, rhs: LocalTime) -> Bool {
        return !(lhs > rhs)
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than or equal to that of the second argument.
    public static func >=(lhs: LocalTime, rhs: LocalTime) -> Bool {
        return !(lhs < rhs)
    }
    
}
extension LocalTime: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    public static func ==(lhs: LocalTime, rhs: LocalTime) -> Bool {
        guard lhs.hour == rhs.hour else { return false }
        guard lhs.minute == rhs.minute else { return false }
        guard lhs.second == rhs.second else { return false }
        guard lhs.nano == rhs.nano else { return false }
        return true
    }
    
}
extension LocalTime: CustomStringConvertible, CustomDebugStringConvertible {
    
    /// A textual representation of this instance.
    public var description: String {
        return String(
            format: "%02d:%02d:%02d.%09ld",
            self.internalHour,
            self.internalMinute,
            self.internalSecond,
            self.internalNano
        )
    }
    
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return String(
            format: "%02d:%02d:%02d.%09ld",
            self.internalHour,
            self.internalMinute,
            self.internalSecond,
            self.internalNano
        )
    }
    
}


// MARK: - Operator

public func + (lhs: LocalTime, rhs: LocalTime) -> LocalTime {
    return LocalTime(
        hour: lhs.hour + rhs.hour,
        minute: lhs.minute + rhs.minute,
        second: lhs.second + rhs.second,
        nanoOfSecond: lhs.nano + rhs.nano
    )
}
public func += (lhs: inout LocalTime, rhs: LocalTime) {
    lhs.hour += rhs.hour
    lhs.minute += rhs.minute
    lhs.second += rhs.second
    lhs.nano += rhs.nano
}
public func - (lhs: LocalTime, rhs: LocalTime) -> LocalTime {
    return LocalTime(
        hour: lhs.hour - rhs.hour,
        minute: lhs.minute - rhs.minute,
        second: lhs.second - rhs.second,
        nanoOfSecond: lhs.nano - rhs.nano
    )
}
public func -= (lhs: inout LocalTime, rhs: LocalTime) {
    lhs.hour -= rhs.hour
    lhs.minute -= rhs.minute
    lhs.second -= rhs.second
    lhs.nano -= rhs.nano
}
