import Foundation

public struct Clock {
    
    // MARK: - Static
    
    /// Obtains a clock that returns the current instant using the best available
    /// system clock, converting to date and time using the UTC time-zone.
    public static var UTC: Clock {
        return Clock(identifier: .utc)
    }

    /// Obtains a clock that returns the current instant using the best available
    /// system clock, converting to date and time using the GMT time-zone.
    public static var GMT: Clock {
        return Clock(identifier: .gmt)
    }

    /// The time zone currently used by the system.
    public static var current: Clock {
        return Clock()
    }

    /// The time zone currently used by the system, automatically updating to the user's current preference.
    /// If this time zone is mutated, then it no longer tracks the system time zone.
    /// The autoupdating time zone only compares equal to itself.
    public static var autoupdatingCurrent: Clock {
        return Clock(identifier: .autoUpdatingCurrent)
    }

    /// Obtains a clock that returns instants from the specified clock with the
    /// specified duration added
    ///
    /// - Parameters:
    ///     - baseClock: The base clock to add the duration to.
    ///     - offsetDuration: The duration to add.
    ///
    /// - Returns: A clock based on the base clock with the duration added.
    public static func offset(baseClock: Clock, offsetDuration: Int) -> Clock {
        return Clock(offsetSecond: baseClock.offsetSecond + offsetDuration)
    }
    
    // MARK: - Property
    
    /// Gets the offset second field.
    public var offsetSecond: Int {
        if self.isAutoUpdatingFromCurrent {
            let oldOffset = self.internalCurrentTimeZone.secondsFromGMT()
            let newOffset = TimeZone.current.secondsFromGMT()
            
            return internalOffset - oldOffset + newOffset
        }
        return internalOffset
    }
    /// Gets the automatically updating status.
    public var isAutoUpdatingFromCurrent: Bool = false
    
    
    // MARK: - Private
    
    fileprivate var internalOffset: Int
    fileprivate var internalCurrentTimeZone = TimeZone.current
    
    
    // MARK: - Public
    
    /// Returns an instance of LocalTime.
    public func toTime() -> LocalTime {
        return LocalTime(secondOfDay: offsetSecond)
    }
    /// Returns an instance of TimeZone.
    public func toTimeZone() -> TimeZone {
        return TimeZone(secondsFromGMT: offsetSecond)!
    }
    
    
    // MARK: - Lifecycle
    
    /// Returns a time zone initialized with a given identifier.
    public init(identifier: ClockIdentifierName) {
        switch identifier {
        case .current:
            self.init(TimeZone.current)
            
        case .autoUpdatingCurrent:
            self.init(TimeZone.current)
            self.isAutoUpdatingFromCurrent = true
            
        default:
            self.init(TimeZone(identifier: identifier.rawValue)!)
        }
    }

    /// Returns a time zone initialized with a given identifier.
    ///
    /// An example identifier is "America/Los_Angeles".
    ///
    /// If `identifier` is an unknown identifier, then returns `nil`.
    public init?(identifier: String) {
        guard let timeZone = TimeZone(identifier: identifier) else { return nil }
        self.init(timeZone)
    }

    /// Creates a time zone from an instance of TimeZone.
    public init(_ timeZone: TimeZone = TimeZone.current) {
        self.internalOffset = timeZone.secondsFromGMT()
    }

    /// Creates a time zone from a hour fields.
    public init(offsetHour hour: Int) {
        self.init(offsetSecond: hour * LocalTime.Constant.secondsPerHour)
    }

    /// Creates a time zone from a minute fields.
    public init(offsetMinute minute: Int) {
        self.init(offsetSecond: minute * LocalTime.Constant.secondsPerMinute)
    }

    /// Creates a time zone from a second fields.
    public init(offsetSecond second: Int) {
        self.internalOffset = second
    }
    
}

extension Clock: Comparable {
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    public static func <(lhs: Clock, rhs: Clock) -> Bool {
        return lhs.offsetSecond < rhs.offsetSecond
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than that of the second argument.
    public static func >(lhs: Clock, rhs: Clock) -> Bool {
        return lhs.offsetSecond > rhs.offsetSecond
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than or equal to that of the second argument.
    public static func <=(lhs: Clock, rhs: Clock) -> Bool {
        return !(lhs > rhs)
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than or equal to that of the second argument.
    public static func >=(lhs: Clock, rhs: Clock) -> Bool {
        return !(lhs < rhs)
    }
    
}
extension Clock: Hashable {

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
        hasher.combine(offsetSecond)
    }
#else
    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    public var hashValue: Int {
        return offsetSecond
    }
#endif
}
extension Clock: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    public static func ==(lhs: Clock, rhs: Clock) -> Bool {
        return lhs.offsetSecond == rhs.offsetSecond
    }
    
}
extension Clock: CustomStringConvertible, CustomDebugStringConvertible {
    
    /// A textual representation of this instance.
    public var description: String {
        return self.toTime().description
    }
    
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return self.toTime().debugDescription
    }
    
}
extension Clock: CustomReflectable {

    /// The custom mirror for this instance.
    ///
    /// If this type has value semantics, the mirror should be unaffected by
    /// subsequent mutations of the instance.
    public var customMirror: Mirror {
        var c = [(label: String?, value: Any)]()
        c.append((label: "offsetSecond", value: self.internalOffset))
        return Mirror(self, children: c, displayStyle: Mirror.DisplayStyle.struct)
    }

}
#if swift(>=4.1) || (swift(>=3.3) && !swift(>=4.0))
extension Clock: CustomPlaygroundDisplayConvertible {
    
    /// Returns the custom playground description for this instance.
    ///
    /// If this type has value semantics, the instance returned should be
    /// unaffected by subsequent mutations if possible.
    public var playgroundDescription: Any {
        return self.description
    }
    
}
#else
extension Clock: CustomPlaygroundQuickLookable {

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
extension Clock: Codable {

    /// A type that can be used as a key for encoding and decoding.
    ///
    /// - offsetSecond: The offset second.
    /// - currentTimeZone: The current time zone offset.
    private enum CodingKeys: String, CodingKey {
        case offsetSecond
        case currentTimeZone = "_curr"
    }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.internalOffset = try container.decode(Int.self, forKey: .offsetSecond)
        
        let seconds = try container.decode(Int.self, forKey: .currentTimeZone)
        self.internalCurrentTimeZone = TimeZone(secondsFromGMT: seconds)!
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
        try container.encode(self.internalOffset, forKey: .offsetSecond)
        try container.encode(self.internalCurrentTimeZone.secondsFromGMT(), forKey: .currentTimeZone)
    }
}
#endif
