import Foundation

public struct Instant {

    // MARK: - Constant

    internal struct Constant {
        /// The minimum supported epoch second.
        static var minSecond: Int64 = -31_557_014_167_219_200

        /// The maximum supported epoch second.
        static var maxSecond: Int64 = 31_556_889_864_403_199
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
    public static func parse(_ text: String, clock: Clock) -> Instant? {
        return Instant.parse(text, timeZone: clock.toTimeZone())
    }
    public static func parse(_ text: String, timeZone: TimeZone = TimeZone.current) -> Instant? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return Instant.parse(text, formatter: formatter, timeZone: timeZone)
    }

    /// Obtains an instance of Instant from a text string using a specific formatter.
    /// If the input text and date format are mismatched, returns nil.
    public static func parse(_ text: String, formatter: DateFormatter, clock: Clock) -> Instant? {
        return Instant.parse(text, formatter: formatter, timeZone: clock.toTimeZone())
    }
    public static func parse(_ text: String, formatter: DateFormatter, timeZone: TimeZone = TimeZone.current) -> Instant? {
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
            nano: Int64(self.internalNano) + (epochMilli % 1000) * 1000_000
        )
    }
    /// Returns a copy of this instant with the specified duration in nanoseconds added.
    public func plus(nano: Int64) -> Instant {
        return Instant(
            epochSecond: self.internalSecond,
            nano: nano
        )
    }
    /// Returns a copy of this instant with the specified duration added.
    public func plus(second: Int64, nano: Int64) -> Instant {
        return Instant(
            epochSecond: self.internalSecond + second,
            nano: Int64(self.internalNano) + nano
        )
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
    public func until(nano endInstant: Instant) -> Int64 {
        let secDiff = endInstant.internalSecond - self.internalSecond
        let totalNano = secDiff * 1000_000_000
        return totalNano - Int64(self.internalNano) + Int64(endInstant.internalNano)
    }
    public func until(second endInstant: Instant) -> Int64 {
        var secDiff = endInstant.internalSecond - self.internalSecond
        let nanoDiff = endInstant.internalNano - self.internalNano
        if secDiff > 0 && nanoDiff < 0 {
            secDiff -= 1
        } else if secDiff < 0 && nanoDiff > 0 {
            secDiff += 1
        }
        return secDiff
    }


    // MARK: - Lifecycle

    /// Creates the current instant from the system clock in the default time-zone.
    public init(clock: Clock) {
        self.init(timeZone: clock.toTimeZone())
    }
    public init(timeZone: TimeZone = TimeZone.current) {
        let date = Date()
        self.init(date, timeZone: timeZone)
    }

    /// Creates an instant from an instance of Date.
    public init(_ date: Date, clock: Clock) {
        self.init(date, timeZone: clock.toTimeZone())
    }
    public init(_ date: Date, timeZone: TimeZone = TimeZone.current) {
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
