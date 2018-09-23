import Foundation

public struct Period {

    // MARK: - Property

    /// Gets the year field.
    public var year: Int {
        get { return self.internalYear }
        set { self.internalYear = newValue; self.normalize() }
    }

    /// Gets the month-of-year field from 1 to 12.
    public var month: Int {
        get { return self.internalMonth }
        set { self.internalMonth = newValue; self.normalize() }
    }

    /// Gets the day-of-month field.
    public var day: Int {
        get { return self.internalDay }
        set { self.internalDay = newValue; self.normalize() }
    }

    /// Gets the hour-of-day field.
    public var hour: Int {
        get { return self.internalHour }
        set { self.internalHour = newValue; self.normalize() }
    }

    /// Gets the minute-of-hour field.
    public var minute: Int {
        get { return self.internalMinute }
        set { self.internalMinute = newValue; self.normalize() }
    }

    /// Gets the second-of-minute field.
    public var second: Int {
        get { return self.internalSecond }
        set { self.internalSecond = newValue; self.normalize() }
    }

    /// Gets the nano-of-second field.
    public var nano: Int {
        get { return self.internalNano }
        set { self.internalNano = newValue; self.normalize() }
    }

    // MARK: - Private

    fileprivate var internalYear: Int
    fileprivate var internalMonth: Int
    fileprivate var internalDay: Int
    fileprivate var internalHour: Int
    fileprivate var internalMinute: Int
    fileprivate var internalSecond: Int
    fileprivate var internalNano: Int

    private mutating func normalize() {
        let year = self.internalYear
        let month = self.internalMonth
        let day = self.internalDay
        let hour = self.internalHour
        let minute = self.internalMinute
        let second = self.internalSecond
        let nano = self.internalNano

        var total = Int64(hour) * LocalTime.Constant.nanosPerHour
        total += Int64(minute) * LocalTime.Constant.nanosPerMinute
        total += Int64(second) * LocalTime.Constant.nanosPerSecond
        total += Int64(nano)
        
        let dayAppend: Int
        if total < 0 {
            dayAppend = Int(total / LocalTime.Constant.nanosPerDay) - 1
            total = (Int64(-dayAppend) * LocalTime.Constant.nanosPerDay) + total
        } else {
            dayAppend = Int(total / LocalTime.Constant.nanosPerDay)
            total %= LocalTime.Constant.nanosPerDay
        }
        
        self.internalNano = Int(total % LocalTime.Constant.nanosPerSecond)
        total /= LocalTime.Constant.nanosPerSecond
        
        self.internalSecond = Int(total % Int64(LocalTime.Constant.secondsPerMinute))
        total /= Int64(LocalTime.Constant.secondsPerMinute)
        
        self.internalMinute = Int(total % Int64(LocalTime.Constant.minutesPerHour))
        self.internalHour = Int(total / Int64(LocalTime.Constant.minutesPerHour))

        let days = day + dayAppend

        var newDate = LocalDate(year: year, month: month + 1, day: days + 1)
        self.internalYear = newDate.year
        self.internalMonth = newDate.month - 1
        self.internalDay = newDate.day - 1
    }

    
    // MARK: - Operator
    
    /// Period
    static public func + (lhs: Period, rhs: Period) -> Period {
        return Period(
            year: lhs.year + rhs.year,
            month: lhs.month + rhs.month,
            day: lhs.day + rhs.day,
            hour: lhs.hour + rhs.hour,
            minute: lhs.minute + rhs.minute,
            second: lhs.second + rhs.second,
            nano: lhs.nano + rhs.nano
        )
    }
    static public func += (lhs: inout Period, rhs: Period) {
        lhs.year += rhs.year
        lhs.month += rhs.month
        lhs.day += rhs.day
        lhs.hour += rhs.hour
        lhs.minute += rhs.minute
        lhs.second += rhs.second
        lhs.nano += rhs.nano
    }
    static public func - (lhs: Period, rhs: Period) -> Period {
        return Period(
            year: lhs.year - rhs.year,
            month: lhs.month - rhs.month,
            day: lhs.day - rhs.day,
            hour: lhs.hour - rhs.hour,
            minute: lhs.minute - rhs.minute,
            second: lhs.second - rhs.second,
            nano: lhs.nano - rhs.nano
        )
    }
    static public func -= (lhs: inout Period, rhs: Period) {
        lhs.year -= rhs.year
        lhs.month -= rhs.month
        lhs.day -= rhs.day
        lhs.hour -= rhs.hour
        lhs.minute -= rhs.minute
        lhs.second -= rhs.second
        lhs.nano -= rhs.nano
    }
    
    /// LocalDateTime
    static public func + (lhs: LocalDateTime, rhs: Period) -> LocalDateTime {
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
    static public func += (lhs: inout LocalDateTime, rhs: Period) {
        lhs.year += rhs.year
        lhs.month += rhs.month
        lhs.day += rhs.day
        lhs.hour += rhs.hour
        lhs.minute += rhs.minute
        lhs.second += rhs.second
        lhs.nano += rhs.nano
    }
    static public func - (lhs: LocalDateTime, rhs: Period) -> LocalDateTime {
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
    static public func -= (lhs: inout LocalDateTime, rhs: Period) {
        lhs.year -= rhs.year
        lhs.month -= rhs.month
        lhs.day -= rhs.day
        lhs.hour -= rhs.hour
        lhs.minute -= rhs.minute
        lhs.second -= rhs.second
        lhs.nano -= rhs.nano
    }
    
    /// ZonedDateTime
    static public func + (lhs: ZonedDateTime, rhs: Period) -> ZonedDateTime {
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
    static public func += (lhs: inout ZonedDateTime, rhs: Period) {
        lhs.year += rhs.year
        lhs.month += rhs.month
        lhs.day += rhs.day
        lhs.hour += rhs.hour
        lhs.minute += rhs.minute
        lhs.second += rhs.second
        lhs.nano += rhs.nano
    }
    static public func - (lhs: ZonedDateTime, rhs: Period) -> ZonedDateTime {
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
    static public func -= (lhs: inout ZonedDateTime, rhs: Period) {
        lhs.year -= rhs.year
        lhs.month -= rhs.month
        lhs.day -= rhs.day
        lhs.hour -= rhs.hour
        lhs.minute -= rhs.minute
        lhs.second -= rhs.second
        lhs.nano -= rhs.nano
    }
    
    
    // MARK: - Lifecycle

    /// Creates an instance of LocalDateTime from year, month,
    /// day, hour, minute, second and nanosecond.
    public init(year: Int = 0, month: Int = 0, day: Int = 0, hour: Int = 0, minute: Int = 0, second: Int = 0, nano: Int = 0) {
        self.internalYear = year
        self.internalMonth = month
        self.internalDay = day
        self.internalHour = hour
        self.internalMinute = minute
        self.internalSecond = second
        self.internalNano = nano
        self.normalize()
    }
}

extension Period: Comparable {
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    public static func <(lhs: Period, rhs: Period) -> Bool {
        guard lhs.year == rhs.year else { return lhs.year < rhs.year }
        guard lhs.month == rhs.month else { return lhs.month < rhs.month }
        guard lhs.day == rhs.day else { return lhs.day < rhs.day }
        guard lhs.hour == rhs.hour else { return lhs.hour < rhs.hour }
        guard lhs.minute == rhs.minute else { return lhs.minute < rhs.minute }
        guard lhs.second == rhs.second else { return lhs.second < rhs.second }
        return lhs.nano < rhs.nano
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than that of the second argument.
    public static func >(lhs: Period, rhs: Period) -> Bool {
        guard lhs.year == rhs.year else { return lhs.year > rhs.year }
        guard lhs.month == rhs.month else { return lhs.month > rhs.month }
        guard lhs.day == rhs.day else { return lhs.day > rhs.day }
        guard lhs.hour == rhs.hour else { return lhs.hour > rhs.hour }
        guard lhs.minute == rhs.minute else { return lhs.minute > rhs.minute }
        guard lhs.second == rhs.second else { return lhs.second > rhs.second }
        return lhs.nano > rhs.nano
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than or equal to that of the second argument.
    public static func <=(lhs: Period, rhs: Period) -> Bool {
        return !(lhs > rhs)
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than or equal to that of the second argument.
    public static func >=(lhs: Period, rhs: Period) -> Bool {
        return !(lhs < rhs)
    }
    
}
extension Period: Hashable {
    
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
        hasher.combine(year)
        hasher.combine(month)
        hasher.combine(day)
        hasher.combine(hour)
        hasher.combine(minute)
        hasher.combine(second)
        hasher.combine(nano)
    }
#else
    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    public var hashValue: Int {
        let dateHash = year.hashValue ^ (51 &* month.hashValue) ^ (17 &* day.hashValue)
        let timeHash = hour.hashValue ^ (51 &* minute.hashValue) ^ (17 &* second.hashValue) ^ (13 &* nano.hashValue)
        return dateHash ^ (13 &* timeHash)
    }
#endif
}
extension Period: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    public static func ==(lhs: Period, rhs: Period) -> Bool {
        guard lhs.year == rhs.year else { return false }
        guard lhs.month == rhs.month else { return false }
        guard lhs.day == rhs.day else { return false }
        guard lhs.hour == rhs.hour else { return false }
        guard lhs.minute == rhs.minute else { return false }
        guard lhs.second == rhs.second else { return false }
        guard lhs.nano == rhs.nano else { return false }
        return true
    }
    
}
extension Period: CustomStringConvertible, CustomDebugStringConvertible {
    
    /// A textual representation of this instance.
    public var description: String {
        let list: [String?] = [
            self.internalYear != 0 ? String(format: "%04dYear ", self.internalYear) : nil,
            self.internalMonth != 0 ? String(format: "%02dMon ", self.internalMonth) : nil,
            self.internalDay != 0 ? String(format: "%02dDay ", self.internalDay) : nil,
            self.internalHour != 0 ? String(format: "%02dHour ", self.internalHour) : nil,
            self.internalMinute != 0 ? String(format: "%02dMin ", self.internalMinute) : nil,
            self.internalSecond != 0 || self.internalNano != 0 ? String(format: "%02d.%09dSec", self.internalSecond, self.internalNano) : nil
        ]
        
        #if swift(>=4.1)
        return list
            .compactMap { $0 }
            .joined()
        #else
        return list
            .flatMap { $0 }
            .joined()
        #endif
    }
    
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return description
    }
    
}
extension Period: CustomReflectable {

    /// The custom mirror for this instance.
    ///
    /// If this type has value semantics, the mirror should be unaffected by
    /// subsequent mutations of the instance.
    public var customMirror: Mirror {
        var c = [(label: String?, value: Any)]()
        c.append((label: "year", value: self.internalYear))
        c.append((label: "month", value: self.internalMonth))
        c.append((label: "day", value: self.internalDay))
        c.append((label: "hour", value: self.internalHour))
        c.append((label: "minute", value: self.internalMinute))
        c.append((label: "second", value: self.internalSecond))
        c.append((label: "nano", value: self.internalNano))
        return Mirror(self, children: c, displayStyle: Mirror.DisplayStyle.struct)
    }

}
#if swift(>=4.1) || (swift(>=3.3) && !swift(>=4.0))
extension Period: CustomPlaygroundDisplayConvertible {
    
    /// Returns the custom playground description for this instance.
    ///
    /// If this type has value semantics, the instance returned should be
    /// unaffected by subsequent mutations if possible.
    public var playgroundDescription: Any {
        return self.description
    }
    
}
#else
extension Period: CustomPlaygroundQuickLookable {

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
extension Period: Codable {

    /// A type that can be used as a key for encoding and decoding.
    ///
    /// - year: The year.
    /// - month: The month-of-year.
    /// - day: The day-of-month.
    /// - hour: The year.
    /// - minute: The minute-of-hour.
    /// - second: The second-of-minute.
    /// - nano: The nano-of-second.
    private enum CodingKeys: Int, CodingKey {
        case year
        case month
        case day
        case hour
        case minute
        case second
        case nano
    }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.internalYear = try container.decode(Int.self, forKey: .year)
        self.internalMonth = try container.decode(Int.self, forKey: .month)
        self.internalDay = try container.decode(Int.self, forKey: .day)
        self.internalHour = try container.decode(Int.self, forKey: .hour)
        self.internalMinute = try container.decode(Int.self, forKey: .minute)
        self.internalSecond = try container.decode(Int.self, forKey: .second)
        self.internalNano = try container.decode(Int.self, forKey: .nano)
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
        try container.encode(self.internalYear, forKey: .year)
        try container.encode(self.internalMonth, forKey: .month)
        try container.encode(self.internalDay, forKey: .day)
        try container.encode(self.internalHour, forKey: .hour)
        try container.encode(self.internalMinute, forKey: .minute)
        try container.encode(self.internalSecond, forKey: .second)
        try container.encode(self.internalNano, forKey: .nano)
    }
}
#endif
