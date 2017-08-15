import Foundation

public struct Clock {
    
    // MARK: - Static
    
    public static var UTC: Clock {
        return Clock(identifier: .utc)
    }
    public static var GMT: Clock {
        return Clock(identifier: .gmt)
    }
    public static var current: Clock {
        return Clock()
    }
    public static var autoupdatingCurrent: Clock {
        return Clock(identifier: .autoUpdatingCurrent)
    }

    public static func offset(baseClock: Clock, offsetDuration: Int) -> Clock {
        return Clock(offsetSecond: baseClock.offsetSecond + offsetDuration)
    }
    
    // MARK: - Property
    
    public var offsetSecond: Int {
        if self.isAutoUpdatingFromCurrent {
            let oldOffset = self.internalCurrentTimeZone.secondsFromGMT()
            let newOffset = TimeZone.current.secondsFromGMT()
            
            return internalOffset - oldOffset + newOffset
        } else {
            return internalOffset
        }
    }
    public var isAutoUpdatingFromCurrent: Bool = false
    
    
    // MARK: - Private
    
    fileprivate var internalOffset: Int
    fileprivate var internalCurrentTimeZone = TimeZone.current
    
    
    // MARK: - Public
    
    public func toTime() -> LocalTime {
        return LocalTime(secondOfDay: offsetSecond)
    }
    public func toTimeZone() -> TimeZone {
        return TimeZone(secondsFromGMT: offsetSecond)!
    }
    
    
    // MARK: - Lifecycle
    
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
    public init?(identifier: String) {
        guard let timeZone = TimeZone(identifier: identifier) else { return nil }
        self.init(timeZone)
    }
    public init(_ timeZone: TimeZone = TimeZone.current) {
        self.internalOffset = timeZone.secondsFromGMT()
    }
    public init(offsetHour hour: Int) {
        self.init(offsetSecond: hour * LocalTime.Constant.secondsPerHour)
    }
    public init(offsetMinute minute: Int) {
        self.init(offsetSecond: minute * LocalTime.Constant.secondsPerMinute)
    }
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
    public var customMirror: Mirror {
        var c = [(label: String?, value: Any)]()
        c.append((label: "offsetSecond", value: self.internalOffset))
        return Mirror(self, children: c, displayStyle: Mirror.DisplayStyle.struct)
    }
}
extension Clock: CustomPlaygroundQuickLookable {
    public var customPlaygroundQuickLook: PlaygroundQuickLook {
        return .text(self.description)
    }
}
