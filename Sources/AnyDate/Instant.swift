import Foundation

public struct Instant {

    // MARK: - Constant

    internal struct Constant {
        /// The minimum supported epoch second.
        static var minSecond: Int64 = -31_557_014_167_219_200

        /// The maximum supported epoch second.
        static var maxSecond: Int64 = 31_556_889_864_403_199
    }
    
    
    // MARK: - Enumerable
    
    public enum Component {
        case second
        case nanosecond
    }
    
    public enum UntilComponent {
        case day
        case hour
        case minute
        case second
        case nanosecond
    }

    
    // MARK: - Static

    /// Constant for the 1970-01-01T00:00:00Z epoch instant.
    public static var epoch: Instant { return Instant(epochSecond: 0, nano: 0) }

    /// The minimum supported Instant, '-1000_000_000-01-01T00:00Z'.
    public static var min: Instant { return Instant(epochSecond: Constant.minSecond, nano: 0) }

    /// The maximum supported Instant, '1000_000_000-12-31T23:59:59.999999999Z'.
    public static var max: Instant { return Instant(epochSecond: Constant.maxSecond, nano: 999_999_999) }


    // MARK: - Property

    /// Gets the number of seconds from the Java epoch of 1970-01-01T00:00:00Z.
    public var second: Int64 {
        get { return self.internalSecond }
        set { self.internalSecond = newValue; self.normalize() }
    }

    /// Gets the number of nanoseconds, later along the time-line, from the start
    /// of the second.
    public var nano: Int {
        get { return self.internalNano }
        set { self.internalNano = newValue; self.normalize() }
    }

    /// Converts this instant to the number of milliseconds from the epoch
    /// of 1970-01-01T00:00:00Z.
    public var epochMilli: Int64 {
        return self.internalSecond * 1000 + Int64(self.internalNano / 1000_000)
    }

    /// Obtains an instance of Instant from a text string such as
    /// "2007-12-03T10:15:30.00Z".
    ///
    /// If the input text and date format are mismatched, returns nil.
    public static func parse(_ text: String, clock: Clock = Clock.UTC) -> Instant? {
        return Instant.parse(text, timeZone: clock.toTimeZone())
    }
    public static func parse(_ text: String, timeZone: TimeZone) -> Instant? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return Instant.parse(text, formatter: formatter, timeZone: timeZone)
    }

    /// Obtains an instance of Instant from a text string using a specific formatter.
    /// If the input text and date format are mismatched, returns nil.
    public static func parse(_ text: String, formatter: DateFormatter, clock: Clock = Clock.UTC) -> Instant? {
        return Instant.parse(text, formatter: formatter, timeZone: clock.toTimeZone())
    }
    public static func parse(_ text: String, formatter: DateFormatter, timeZone: TimeZone) -> Instant? {
        formatter.timeZone = timeZone

        guard let date = formatter.date(from: text) else { return nil }
        return Instant(date)
    }


    // MARK: - Private

    fileprivate var internalSecond: Int64
    fileprivate var internalNano: Int

    private mutating func normalize() {
        if self.internalNano < 0 {
            let count = Int(ceil(-Double(self.internalNano) / 1000_000_000))
            self.internalSecond -= Int64(count)
            self.internalNano += 1000_000_000 * count
        } else {
            self.internalSecond += Int64(self.internalNano / 1000_000_000)
            self.internalNano %= 1000_000_000
        }
    }
    private func until(nano endInstant: Instant) -> Int64 {
        let secDiff = endInstant.internalSecond - self.internalSecond
        let totalNano = secDiff * 1000_000_000
        return totalNano - Int64(self.internalNano) + Int64(endInstant.internalNano)
    }
    private func until(second endInstant: Instant) -> Int64 {
        var secDiff = endInstant.internalSecond - self.internalSecond
        let nanoDiff = endInstant.internalNano - self.internalNano
        if secDiff > 0 && nanoDiff < 0 {
            secDiff -= 1
        } else if secDiff < 0 && nanoDiff > 0 {
            secDiff += 1
        }
        return secDiff
    }


    // MARK: - Public

    /// Combines this instant with a time-zone to create a ZonedDateTime.
    public func toZone(clock: Clock = Clock.current) -> ZonedDateTime {
        let nanoAdd = self.internalSecond % 86400
        let dayAdd = self.internalSecond / 86400

        return ZonedDateTime(
            epochDay: dayAdd,
            nanoOfDay: Int64(self.internalNano) + nanoAdd * 1000_000_000,
            clock: clock
        )
    }

    /// Returns a copy of this instant with the specified field set to a new value.
    public func with(component: Component, newValue: Int64) -> Instant {
        switch component {
        case .second:
            return self.with(second: newValue)
            
        case .nanosecond:
            return self.with(nano: newValue)
        }
    }

    /// Returns a copy of this Instant with the second-of-minute value altered.
    public func with(second: Int64) -> Instant {
        return Instant(
            epochSecond: second,
            nano: Int64(self.internalNano)
        )
    }

    /// Returns a copy of this Instant with the nano-of-second value altered.
    public func with(nano: Int64) -> Instant {
        return Instant(
            epochSecond: self.internalSecond,
            nano: nano
        )
    }

    /// Returns a copy of this instant with the specified amount added.
    public func plus(component: Component, newValue: Int64) -> Instant {
        switch component {
        case .second:
            return self.plus(second: newValue)
            
        case .nanosecond:
            return self.plus(nano: newValue)
        }
    }

    /// Returns a copy of this instant with the specified duration in seconds added.
    public func plus(second: Int64) -> Instant {
        return Instant(
            epochSecond: self.internalSecond + second,
            nano: Int64(self.internalNano)
        )
    }

    /// Returns a copy of this instant with the specified duration in milliseconds added.
    public func plus(milli: Int64) -> Instant {
        return Instant(
            epochSecond: self.internalSecond + milli / 1000,
            nano: Int64(self.internalNano) + (milli % 1000) * 1000_000
        )
    }

    /// Returns a copy of this instant with the specified duration in nanoseconds added.
    public func plus(nano: Int64) -> Instant {
        return Instant(
            epochSecond: self.internalSecond,
            nano: Int64(self.internalNano) + nano
        )
    }

    /// Returns a copy of this instant with the specified duration added.
    public func plus(second: Int64, nano: Int64) -> Instant {
        return Instant(
            epochSecond: self.internalSecond + second,
            nano: Int64(self.internalNano) + nano
        )
    }

    /// Returns a copy of this instant with the specified amount added.
    public func minus(component: Component, newValue: Int64) -> Instant {
        switch component {
        case .second:
            return self.minus(second: newValue)
            
        case .nanosecond:
            return self.minus(nano: newValue)
        }
    }

    /// Returns a copy of this instant with the specified duration in seconds subtracted.
    public func minus(second: Int64) -> Instant {
        return self.plus(second: -second)
    }

    /// Returns a copy of this instant with the specified duration in milliseconds subtracted.
    public func minus(milli: Int64) -> Instant {
        return self.plus(milli: -milli)
    }

    /// Returns a copy of this instant with the specified duration in nanoseconds subtracted.
    public func minus(nano: Int64) -> Instant {
        return self.plus(nano: -nano)
    }

    /// Returns a copy of this instant with the specified duration subtracted.
    public func minus(second: Int64, nano: Int64) -> Instant {
        return self.plus(second: -second, nano: -nano)
    }

    /// Calculates the amount of time until another instant in terms of the specified unit.
    public func until(endInstant: Instant, component: UntilComponent) -> Int64 {
        switch component {
        case .nanosecond:
            return self.until(nano: endInstant)
        case .second:
            return self.until(second: endInstant)
        case .minute:
            return self.until(second: endInstant) / Int64(LocalTime.Constant.secondsPerMinute)
        case .hour:
            return self.until(second: endInstant) / Int64(LocalTime.Constant.secondsPerHour)
        case .day:
            return self.until(second: endInstant) / Int64(LocalTime.Constant.secondsPerDay)
        }
    }

    
    // MARK: - Operator
    
    static public func + (lhs: Instant, rhs: Instant) -> Instant {
        return Instant(
            epochSecond: lhs.internalSecond + rhs.internalSecond,
            nano: Int64(lhs.internalNano + rhs.internalNano)
        )
    }
    static public func += (lhs: inout Instant, rhs: Instant) {
        lhs.internalSecond += rhs.internalSecond
        lhs.internalNano += rhs.internalNano
        lhs.normalize()
    }
    static public func - (lhs: Instant, rhs: Instant) -> Instant {
        return Instant(
            epochSecond: lhs.internalSecond - rhs.internalSecond,
            nano: Int64(lhs.internalNano - rhs.internalNano)
        )
    }
    static public func -= (lhs: inout Instant, rhs: Instant) {
        lhs.internalSecond -= rhs.internalSecond
        lhs.internalNano -= rhs.internalNano
        lhs.normalize()
    }
    

    // MARK: - Lifecycle

    /// Creates an instant from an instance of Date.
    public init(_ date: Date = Date()) {
        let interval = Double(date.timeIntervalSince1970)

        self.internalSecond = Int64(interval)
        self.internalNano = Int((interval - Double(self.internalSecond)) * 1000_000_000)
        self.normalize()
    }

    /// Creates an instance of Instant using seconds from the
    /// epoch of 1970-01-01T00:00:00Z.
    public init(epochSecond: Int64, nano: Int64 = 0) {
        self.internalSecond = epochSecond + nano / 1000_000_000
        self.internalNano = Int(nano % 1000_000_000)
        self.normalize()
    }

    /// Creates an instance of Instant using milliseconds from the
    /// epoch of 1970-01-01T00:00:00Z.
    public init(epochMilli: Int64) {
        self.internalSecond = epochMilli / 1000
        self.internalNano = Int(epochMilli % 1000) * 1000_000
        self.normalize()
    }
}

extension Instant: Comparable {
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    public static func <(lhs: Instant, rhs: Instant) -> Bool {
        if lhs.second < rhs.second { return true }
        if lhs.nano < rhs.nano { return true }
        return false
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than that of the second argument.
    public static func >(lhs: Instant, rhs: Instant) -> Bool {
        if lhs.second > rhs.second { return true }
        if lhs.nano > rhs.nano { return true }
        return false
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than or equal to that of the second argument.
    public static func <=(lhs: Instant, rhs: Instant) -> Bool {
        return !(lhs > rhs)
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than or equal to that of the second argument.
    public static func >=(lhs: Instant, rhs: Instant) -> Bool {
        return !(lhs < rhs)
    }
    
}
extension Instant: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    public static func ==(lhs: Instant, rhs: Instant) -> Bool {
        return lhs.second == rhs.second && lhs.nano == rhs.nano
    }
    
}
extension Instant: CustomStringConvertible, CustomDebugStringConvertible {
    
    /// A textual representation of this instance.
    public var description: String {
        return "\(self.second).\(self.nano)"
    }
    
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return description
    }
    
}
extension Instant: CustomReflectable {
    public var customMirror: Mirror {
        var c = [(label: String?, value: Any)]()
        c.append((label: "second", value: self.second))
        c.append((label: "nano", value: self.nano))
        return Mirror(self, children: c, displayStyle: Mirror.DisplayStyle.struct)
    }
}
extension Instant: CustomPlaygroundQuickLookable {
    public var customPlaygroundQuickLook: PlaygroundQuickLook {
        return .text(self.description)
    }
}

#if swift(>=3.2)
extension Instant: Codable {
    private enum CodingKeys: Int, CodingKey {
        case second
        case nano
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.internalSecond = try container.decode(Int64.self, forKey: .second)
        self.internalNano = try container.decode(Int.self, forKey: .nano)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.internalSecond, forKey: .second)
        try container.encode(self.internalNano, forKey: .nano)
    }
}
#endif
