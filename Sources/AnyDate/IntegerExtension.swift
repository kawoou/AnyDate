import Foundation

public extension BinaryInteger {

    /// Obtains the Period instance for the year.
    var year: Period {
        return Period(year: Int(self), month: 0, day: 0, hour: 0, minute: 0, second: 0, nano: 0)
    }
    
    /// Obtains the Period instance for the month.
    var month: Period {
        return Period(year: 0, month: Int(self), day: 0, hour: 0, minute: 0, second: 0, nano: 0)
    }

    /// Obtains the Period instance for the week.
    var week: Period {
        return Period(year: 0, month: 0, day: Int(self) * 7, hour: 0, minute: 0, second: 0, nano: 0)
    }

    /// Obtains the Period instance for the day.
    var day: Period {
        return Period(year: 0, month: 0, day: Int(self), hour: 0, minute: 0, second: 0, nano: 0)
    }

    /// Obtains the Period instance for the hour.
    var hour: Period {
        return Period(year: 0, month: 0, day: 0, hour: Int(self), minute: 0, second: 0, nano: 0)
    }

    /// Obtains the Period instance for the minute.
    var minute: Period {
        return Period(year: 0, month: 0, day: 0, hour: 0, minute: Int(self), second: 0, nano: 0)
    }

    /// Obtains the Period instance for the second.
    var second: Period {
        return Period(year: 0, month: 0, day: 0, hour: 0, minute: 0, second: Int(self), nano: 0)
    }

    /// Obtains the Period instance for the nano-of-second.
    var nanosecond: Period {
        return Period(year: 0, month: 0, day: 0, hour: 0, minute: 0, second: 0, nano: Int(self))
    }

}
