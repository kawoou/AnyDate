import Foundation

public extension Int {

    /// Obtains the Period instance for the year.
    public var year: Period {
        return Period(year: self, month: 0, day: 0, hour: 0, minute: 0, second: 0, nano: 0)
    }
    
    /// Obtains the Period instance for the month.
    public var month: Period {
        return Period(year: 0, month: self, day: 0, hour: 0, minute: 0, second: 0, nano: 0)
    }

    /// Obtains the Period instance for the week.
    public var week: Period {
        return Period(year: 0, month: 0, day: self * 7, hour: 0, minute: 0, second: 0, nano: 0)
    }

    /// Obtains the Period instance for the day.
    public var day: Period {
        return Period(year: 0, month: 0, day: self, hour: 0, minute: 0, second: 0, nano: 0)
    }

    /// Obtains the Period instance for the hour.
    public var hour: Period {
        return Period(year: 0, month: 0, day: 0, hour: self, minute: 0, second: 0, nano: 0)
    }

    /// Obtains the Period instance for the minute.
    public var minute: Period {
        return Period(year: 0, month: 0, day: 0, hour: 0, minute: self, second: 0, nano: 0)
    }

    /// Obtains the Period instance for the second.
    public var second: Period {
        return Period(year: 0, month: 0, day: 0, hour: 0, minute: 0, second: self, nano: 0)
    }

    /// Obtains the Period instance for the nano-of-second.
    public var nanosecond: Period {
        return Period(year: 0, month: 0, day: 0, hour: 0, minute: 0, second: 0, nano: self)
    }

}
