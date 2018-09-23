import Foundation

public struct LocalDate {
    
    // MARK: - Constant
    
    internal struct Constant {
        /// The pre-summed day of the month.
        static fileprivate let sumMonth = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365]

        /// The minimum supported month, '+1'
        static public let minMonth = 1
        
        /// The maximum supported month, '+12'
        static public let maxMonth = 12
        
        /// The minimum supported year, '-999,999,999'.
        static public let minYear = -999_999_999
        
        /// The maximum supported year, '+999,999,999'.
        static public let maxYear = 999_999_999
        
        /// The number of days in a 400 year cycle.
        static public let daysPerCycle = 146097
        
        /// The number of days from year zero to year 1970.
        /// There are five 400 year cycles from year zero to 2000.
        ///  There are 7 leap years from 1970 to 2000.
        static public let daysZeroTo1970 = Int64((Constant.daysPerCycle * 5) - (30 * 365 + 7))
    }
    
    
    // MARK: - Enumerable
    
    public enum Component: String {
        case year
        case month
        case day
    }
    public enum PlusComponent: String {
        case year
        case month
        case weekday
        case day
    }
    public enum RangeComponent: String {
        case era
        case year
        case month
        case weekday
        case weekOfMonth
    }
    public enum UntilComponent: String {
        case year
        case month
        case weekday
        case day
    }
    
    
    // MARK: - Static
    
    /// The minimum supported LocalDate, '-999999999-01-01'.
    /// This could be used by an application as a "far past" date.
    static public var min: LocalDate {
        return LocalDate(year: Constant.minYear, month: Constant.minMonth, day: 1)
    }
    
    /// The maximum supported LocalDate, '+999999999-12-31'.
    /// This could be used by an application as a "far future" date.
    static public var max: LocalDate {
        var date = LocalDate(year: Constant.maxYear, month: Constant.maxMonth, day: 1)
        date.day = date.lengthOfMonth()
        
        return date
    }
    
    /// Obtains an instance of LocalDate from a text string such as "2007-12-03".
    ///
    /// If the input text and date format are mismatched, returns nil.
    ///
    /// - Parameters:
    ///     - text: The text to parse.
    ///     - clock: The Clock instance.
    /// - Returns: The parsed local date.
    static public func parse(_ text: String, clock: Clock) -> LocalDate? {
        return LocalDate.parse(text, timeZone: clock.toTimeZone())
    }

    /// Obtains an instance of LocalDate from a text string such as "2007-12-03".
    ///
    /// If the input text and date format are mismatched, returns nil.
    ///
    /// - Parameters:
    ///     - text: The text to parse.
    ///     - timeZone: The TimeZone instance.
    /// - Returns: The parsed local date.
    static public func parse(_ text: String, timeZone: TimeZone = TimeZone.current) -> LocalDate? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return LocalDate.parse(text, formatter: formatter, timeZone: timeZone)
    }
    
    /// Obtains an instance of LocalDate from a text string using a specific formatter.
    ///
    /// If the input text and date format are mismatched, returns nil.
    ///
    /// - Parameters:
    ///     - text: The text to parse.
    ///     - formatter: The formatter to parse.
    ///     - clock: The Clock instance.
    /// - Returns: The parsed local date.
    static public func parse(_ text: String, formatter: DateFormatter, clock: Clock) -> LocalDate? {
        return LocalDate.parse(text, formatter: formatter, timeZone: clock.toTimeZone())
    }

    /// Obtains an instance of LocalDate from a text string using a specific formatter.
    ///
    /// If the input text and date format are mismatched, returns nil.
    ///
    /// - Parameters:
    ///     - text: The text to parse.
    ///     - formatter: The formatter to parse.
    ///     - timeZone: The TimeZone instance.
    /// - Returns: The parsed local date.
    static public func parse(_ text: String, formatter: DateFormatter, timeZone: TimeZone = TimeZone.current) -> LocalDate? {
        formatter.timeZone = timeZone

        guard let date = formatter.date(from: text) else { return nil }
        return LocalDate(date)
    }
    

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
    
    /// Gets the day-of-week field.
    ///
    /// The start of one week is Monday.
    ///
    /// - Returns:
    ///     - Monday = 0
    ///     - Tuesday = 1
    ///     - Wednesday = 2
    ///     - Thursday = 3
    ///     - Friday = 4
    ///     - Saturday = 5
    ///     - Sunday = 6
    public var dayOfWeek: Int {
        let ly = self.internalYear - 1
        let lm = self.internalMonth - 1
        let ld = self.internalDay - 1

        var total = ly * 365 + ly / 400 - ly / 100 + ly / 4

        /// for B.C.
        if total < 0 {
            total -= 1
        }

        total += Constant.sumMonth[lm]
        if self.isLeapYear(year: self.internalYear) && lm >= 2 {
            total += 1
        }
        total += ld

        return total < 0 ? 7 + (total % 7) : total % 7
    }
    
    /// Gets the epoch day count represented by this date.
    public var epochDay: Int64 {
        return self.toEpochDay()
    }
    
    
    // MARK: - Private
    
    fileprivate var internalYear: Int
    fileprivate var internalMonth: Int
    fileprivate var internalDay: Int
    
    private var prolepticMonth: Int64 {
        return Int64(self.internalYear) * 12 + Int64(self.internalMonth - 1)
    }
    
    private func dayUntil(endDate: LocalDate) -> Int64 {
        return endDate.epochDay - self.epochDay
    }
    private func monthUntil(endDate: LocalDate) -> Int64 {
        let packed1 = self.prolepticMonth * 32 + Int64(self.day)
        let packed2 = endDate.prolepticMonth * 32 + Int64(endDate.day)
        return (packed2 - packed1) / 32
    }
    
    
    private func lengthOfMonth(year: Int, month: Int) -> Int {
        switch month {
        case 2:
            return self.isLeapYear(year: year) ? 29 : 28
            
        case 4, 6, 9, 11:
            return 30
            
        default:
            return 31
        }
    }
    private func isLeapYear(year: Int) -> Bool {
        guard year & 3 == 0 else { return false }
        return (year % 100) != 0 || (year % 400) == 0
    }
    private func isValid() -> Bool {
        guard self.internalMonth >= Constant.minMonth else { return false }
        guard self.internalMonth <= Constant.maxMonth else { return false }
        guard self.internalDay >= 1 else { return false }
        guard self.internalDay <= self.lengthOfMonth(year: self.internalYear, month: self.internalMonth) else { return false }
        
        return true
    }
    
    private func toEpochDay() -> Int64 {
        let y = Int64(self.internalYear)
        let m = Int64(self.internalMonth)
        let d = Int64(self.internalDay)
        var total = Int64(0)
        
        total += 365 * y
        if y >= 0 {
            total += (y + 3) / 4
            total -= (y + 99) / 100
            total += (y + 399) / 400
        } else {
            total -= y / -4
            total -= y / -100
            total += y / -400
        }
        total += ((367 * m - 362) / 12)
        total += d - 1
        
        if m > 2 {
            total -= 1
            if !self.isLeapYear(year: Int(y)) {
                total -= 1
            }
        }
        return total - Constant.daysZeroTo1970
    }
    
    fileprivate mutating func normalize() {
        guard !isValid() else { return }
        
        let monthCount = Int64(self.internalYear * 12) + Int64(self.internalMonth - 1)
        self.internalYear = Int(floor(Double(monthCount) / 12))
        self.internalMonth = Int(monthCount % 12) + 1
        
        let newDate = LocalDate(epochDay: self.toEpochDay())
        self.internalYear = newDate.internalYear
        self.internalMonth = newDate.internalMonth
        self.internalDay = newDate.internalDay
    }
    
    
    // MARK: - Public
    
    /// Returns the length of the month represented by this date.
    public func lengthOfMonth() -> Int {
        return self.lengthOfMonth(year: self.internalYear, month: self.internalMonth)
    }
    
    /// Returns the length of the year represented by this date.
    public func lengthOfYear() -> Int {
        return self.isLeapYear(year: self.internalYear) ? 366 : 365
    }
    
    /// Checks if the year is a leap year, according to the ISO proleptic
    /// calendar system rules.
    public func isLeapYear() -> Bool {
        return self.isLeapYear(year: self.internalYear)
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
        dateComponents.year = self.internalYear
        dateComponents.month = self.internalMonth
        dateComponents.day = self.internalDay
        
        /// Create date from components
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        return calendar.date(from: dateComponents)!
    }
    
    /// Returns a copy of this date with the specified field set to a new value.
    ///
    /// - Parameters:
    ///     - component: The field to set in the result.
    ///     - newValue: The new value of the field in the result.
    /// - Returns: An LocalDate based on this with the specified field set.
    public func with(component: Component, newValue: Int) -> LocalDate {
        switch component {
        case .year:
            return self.with(year: newValue)
            
        case .month:
            return self.with(month: newValue)
            
        case .day:
            return self.with(dayOfMonth: newValue)
        }
    }
    
    /// Returns a copy of this date with the year altered.
    ///
    /// - Parameters year: The new value of the year field in the result.
    /// - Returns: An LocalDate based on this with the specified field set.
    public func with(year: Int) -> LocalDate {
        return LocalDate(year: year, month: self.month, day: self.day)
    }
    
    /// Returns a copy of this date with the month-of-year altered.
    ///
    /// - Parameters month: The new value of the month field in the result.
    /// - Returns: An LocalDate based on this with the specified field set.
    public func with(month: Int) -> LocalDate {
        return LocalDate(year: self.year, month: month, day: self.day)
    }
    
    /// Returns a copy of this date with the day-of-month altered.
    ///
    /// - Parameters dayOfMonth: The new value of the day-of-month field in the result.
    /// - Returns: An LocalDate based on this with the specified field set.
    public func with(dayOfMonth: Int) -> LocalDate {
        return LocalDate(year: self.year, month: self.month, day: dayOfMonth)
    }
    
    /// Returns a copy of this date with the day-of-year altered.
    ///
    /// - Parameters dayOfYear: The new value of the day-of-year field in the result.
    /// - Returns: An LocalDate based on this with the specified field set.
    public func with(dayOfYear: Int) -> LocalDate {
        return LocalDate(year: self.year, month: 1, day: dayOfYear)
    }
    
    /// Returns a copy of this date with the specified amount added.
    ///
    /// - Parameters:
    ///     - component: The unit of the amount to add.
    ///     - newValue: The amount of the unit to add to the result.
    /// - Results: An LocalDate based on this date with the specified amount added.
    public func plus(component: PlusComponent, newValue: Int) -> LocalDate {
        switch component {
        case .year:
            return self.plus(year: newValue)
            
        case .month:
            return self.plus(month: newValue)
            
        case .weekday:
            return self.plus(week: newValue)
            
        case .day:
            return self.plus(day: newValue)
        }
    }
    
    /// Returns a copy of this LocalDate with the specified period in years added.
    ///
    /// - Parameters year: The amount of the year field to add to the result.
    /// - Results: An LocalDate based on this date with the specified amount added.
    public func plus(year: Int) -> LocalDate {
        return LocalDate(year: self.internalYear + year, month: self.internalMonth, day: self.internalDay)
    }
    
    /// Returns a copy of this LocalDate with the specified period in months added.
    ///
    /// - Parameters month: The amount of the month field to add to the result.
    /// - Results: An LocalDate based on this date with the specified amount added.
    public func plus(month: Int) -> LocalDate {
        return LocalDate(year: self.internalYear, month: self.internalMonth + month, day: self.internalDay)
    }
    
    /// Returns a copy of this LocalDate with the specified period in weeks added.
    ///
    /// - Parameters week: The amount of the week field to add to the result.
    /// - Results: An LocalDate based on this date with the specified amount added.
    public func plus(week: Int) -> LocalDate {
        return LocalDate(year: self.internalYear, month: self.internalMonth, day: self.internalDay + week * 7)
    }
    
    /// Returns a copy of this LocalDate with the specified number of days added.
    ///
    /// - Parameters day: The amount of the day field to add to the result.
    /// - Results: An LocalDate based on this date with the specified amount added.
    public func plus(day: Int) -> LocalDate {
        return LocalDate(year: self.internalYear, month: self.internalMonth, day: self.internalDay + day)
    }
    
    /// Returns a copy of this date with the specified amount subtracted.
    ///
    /// - Parameters:
    ///     - component: The unit of the amount to subtract.
    ///     - newValue: The amount of the unit to subtract to the result.
    /// - Results: An LocalDate based on this date with the specified amount subtracted.
    public func minus(component: PlusComponent, newValue: Int) -> LocalDate {
        return self.plus(component: component, newValue: -newValue)
    }
    
    /// Returns a copy of this LocalDate with the specified period in years subtracted.
    ///
    /// - Parameters year: The amount of the year field to subtract to the result.
    /// - Results: An LocalDate based on this date with the specified amount subtracted.
    public func minus(year: Int) -> LocalDate {
        return self.plus(year: -year)
    }
    
    /// Returns a copy of this LocalDate with the specified period in months subtracted.
    ///
    /// - Parameters month: The amount of the month field to subtract to the result.
    /// - Results: An LocalDate based on this date with the specified amount subtracted.
    public func minus(month: Int) -> LocalDate {
        return self.plus(month: -month)
    }
    
    /// Returns a copy of this LocalDate with the specified period in weeks subtracted.
    ///
    /// - Parameters week: The amount of the week field to subtract to the result.
    /// - Results: An LocalDate based on this date with the specified amount subtracted.
    public func minus(week: Int) -> LocalDate {
        return self.plus(week: -week)
    }
    
    /// Returns a copy of this LocalDate with the specified number of days subtracted.
    ///
    /// - Parameters day: The amount of the day field to subtract to the result.
    /// - Results: An LocalDate based on this date with the specified amount subtracted.
    public func minus(day: Int) -> LocalDate {
        return self.plus(day: -day)
    }
    
    /// Gets the range of valid values for the specified field.
    ///
    /// The start of one week is Monday.
    ///
    /// - Parameters component: The field to query the range for.
    /// - Returns: The range of valid values for the field.
    public func range(_ component: RangeComponent) -> (Int, Int) {
        switch component {
        case .weekday:
            let date = LocalDate(year: self.internalYear, month: self.internalMonth, day: 1)
            return (1, Int(ceil(Double(date.dayOfWeek + self.lengthOfMonth()) / 7)))

        case .month:
            return (1, self.lengthOfMonth())

        case .year:
            return (1, self.lengthOfYear())
            
        case .weekOfMonth:
            return (1, self.month == 2 && !self.isLeapYear() ? 4 : 5)
            
        case .era:
            if self.year <= 0 {
                return (1, Constant.maxYear + 1)
            } else {
                return (1, Constant.maxYear)
            }
        }
    }
    
    /// Calculates the period between this date and another date as a Period.
    ///
    /// - Parameters:
    ///     - endDate: The end date, exclusive, which is converted to an LocalDate.
    /// - Returns: The Period of time between this date and the end date.
    public func until(endDate: LocalDate) -> Period {
        var totalMonth = endDate.prolepticMonth - self.prolepticMonth
        var days = endDate.day - self.day
        
        if totalMonth > 0 && days < 0 {
            totalMonth -= 1
            
            var calcDate = LocalDate(self)
            calcDate.month += Int(totalMonth)
            days = Int(endDate.epochDay - calcDate.epochDay)
        } else if totalMonth < 0 && days > 0 {
            totalMonth += 1
            days -= endDate.lengthOfMonth()
        }
        
        let years = Int(totalMonth / 12)
        let months = Int(totalMonth % 12)
        return Period(year: years, month: months, day: days, hour: 0, minute: 0, second: 0, nano: 0)
    }
    
    /// Calculates the amount of time until another date in terms of the specified unit.
    ///
    /// - Parameters:
    ///     - endDate: The end date, exclusive, which is converted to an LocalDate.
    ///     - component: The unit to measure the amount in.
    /// - Returns: The amount of time between this date and the end date.
    public func until(endDate: LocalDate, component: UntilComponent) -> Int64 {
        switch component {
        case .day:
            return self.dayUntil(endDate: endDate)
            
        case .weekday:
            return self.dayUntil(endDate: endDate) / 7
            
        case .month:
            return self.monthUntil(endDate: endDate)
            
        case .year:
            return self.monthUntil(endDate: endDate) / 12
        }
    }
    
    /// Formats this date using the specified formatter.
    ///
    /// - Parameters formatter: The formatter to use.
    /// - Returns: The formatted date string.
    public func format(_ formatter: DateFormatter) -> String {
        return formatter.string(from: self.toDate())
    }
    
    
    // MARK: - Operator
    
    static public func + (lhs: LocalDate, rhs: LocalDate) -> LocalDate {
        return LocalDate(
            year: lhs.year + rhs.year,
            month: lhs.month + rhs.month,
            day: lhs.day + rhs.day
        )
    }
    static public func += (lhs: inout LocalDate, rhs: LocalDate) {
        lhs.year += rhs.year
        lhs.month += rhs.month
        lhs.day += rhs.day
    }
    static public func - (lhs: LocalDate, rhs: LocalDate) -> LocalDate {
        return LocalDate(
            year: lhs.year - rhs.year,
            month: lhs.month - rhs.month,
            day: lhs.day - rhs.day
        )
    }
    static public func -= (lhs: inout LocalDate, rhs: LocalDate) {
        lhs.year -= rhs.year
        lhs.month -= rhs.month
        lhs.day -= rhs.day
    }
    
    
    // MARK: - Lifecycle
    
    /// Creates the current date from the time-zone.
    public init(clock: Clock) {
        self.init(timeZone: clock.toTimeZone())
    }

    /// Creates the current date from the time-zone.
    public init(timeZone: TimeZone = TimeZone.current) {
        let now = Date()
        
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        self.internalYear = calendar.component(.year, from: now)
        self.internalMonth = calendar.component(.month, from: now)
        self.internalDay = calendar.component(.day, from: now)
        self.normalize()
    }
    
    /// Creates a local date from an instance of Date.
    public init(_ date: Date, clock: Clock) {
        self.init(date, timeZone: clock.toTimeZone())
    }

    /// Creates a local date from an instance of Date.
    public init(_ date: Date, timeZone: TimeZone = TimeZone.current) {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        self.internalYear = calendar.component(.year, from: date)
        self.internalMonth = calendar.component(.month, from: date)
        self.internalDay = calendar.component(.day, from: date)
        self.normalize()
    }
    
    /// Copies an instance of LocalDate.
    public init(_ date: LocalDate) {
        self.internalYear = date.year
        self.internalMonth = date.month
        self.internalDay = date.day
        self.normalize()
    }
    
    /// Creates a local date from a month and day fields.
    public init(month: Int, day: Int) {
        self.internalYear = 0
        self.internalMonth = month
        self.internalDay = day
        self.normalize()
    }
    
    /// Creates a local date from the year, month and day fields.
    public init(year: Int, month: Int, day: Int) {
        self.internalYear = year
        self.internalMonth = month
        self.internalDay = day
        self.normalize()
    }
    
    /// Creates a local date from a year and day-of-year fields.
    public init(year: Int, dayOfYear: Int) {
        self.internalYear = year
        self.internalMonth = 1
        self.internalDay = dayOfYear
        self.normalize()
    }
    
    /// Creates a local date from the epoch day count fields.
    public init(epochDay: Int64) {
        var zeroDay = epochDay + Constant.daysZeroTo1970
        
        /// find the march-based year
        /// adjust to 0000-03-01 so leap day is at end of four year cycle
        zeroDay -= 60
        
        var adjust = Int64(0)
        if zeroDay < 0 {
            /// adjust negative years to positive for calculation
            let adjustCycles = (zeroDay + 1) / Int64(Constant.daysPerCycle) - 1
            adjust = adjustCycles * 400
            zeroDay += -adjustCycles * Int64(Constant.daysPerCycle)
        }
        
        var yearEst = (400 * zeroDay + 591) / Int64(Constant.daysPerCycle)
        var doyEst = zeroDay - (365 * yearEst + yearEst / 4 - yearEst / 100 + yearEst / 400)
        if doyEst < 0 {
            /// fix estimate
            yearEst -= 1
            doyEst = zeroDay - (365 * yearEst + yearEst / 4 - yearEst / 100 + yearEst / 400)
        }
        /// reset any negative year
        yearEst += adjust
        
        /// convert march-based values back to january-based
        let marchMonthZero = Int((doyEst * 5 + 2) / 153)
        
        self.internalYear = Int(yearEst) + marchMonthZero / 10
        self.internalMonth = (marchMonthZero + 2) % 12 + 1
        self.internalDay = Int(doyEst) - (marchMonthZero * 306 + 5) / 10 + 1
        self.normalize()
    }
    
}

extension LocalDate: Comparable {
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    public static func <(lhs: LocalDate, rhs: LocalDate) -> Bool {
        guard lhs.year == rhs.year else { return lhs.year < rhs.year }
        guard lhs.month == rhs.month else { return lhs.month < rhs.month }
        return lhs.day < rhs.day
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than that of the second argument.
    public static func >(lhs: LocalDate, rhs: LocalDate) -> Bool {
        guard lhs.year == rhs.year else { return lhs.year > rhs.year }
        guard lhs.month == rhs.month else { return lhs.month > rhs.month }
        return lhs.day > rhs.day
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than or equal to that of the second argument.
    public static func <=(lhs: LocalDate, rhs: LocalDate) -> Bool {
        return !(lhs > rhs)
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than or equal to that of the second argument.
    public static func >=(lhs: LocalDate, rhs: LocalDate) -> Bool {
        return !(lhs < rhs)
    }
    
}
extension LocalDate: Hashable {
    
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
    }
#else
    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    public var hashValue: Int {
        return year.hashValue ^ (51 &* month.hashValue) ^ (17 &* day.hashValue)
    }
#endif
}
extension LocalDate: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    public static func ==(lhs: LocalDate, rhs: LocalDate) -> Bool {
        guard lhs.year == rhs.year else { return false }
        guard lhs.month == rhs.month else { return false }
        guard lhs.day == rhs.day else { return false }
        return true
    }
    
}
extension LocalDate: CustomStringConvertible, CustomDebugStringConvertible {
    
    /// A textual representation of this instance.
    public var description: String {
        return String(
            format: "%02d.%02d.%02d",
            self.internalYear,
            self.internalMonth,
            self.internalDay
        )
    }
    
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return description
    }
    
}
extension LocalDate: CustomReflectable {

    /// The custom mirror for this instance.
    ///
    /// If this type has value semantics, the mirror should be unaffected by
    /// subsequent mutations of the instance.
    public var customMirror: Mirror {
        var c = [(label: String?, value: Any)]()
        c.append((label: "year", value: self.internalYear))
        c.append((label: "month", value: self.internalMonth))
        c.append((label: "day", value: self.internalDay))
        return Mirror(self, children: c, displayStyle: Mirror.DisplayStyle.struct)
    }

}
#if swift(>=4.1) || (swift(>=3.3) && !swift(>=4.0))
extension LocalDate: CustomPlaygroundDisplayConvertible {
    
    /// Returns the custom playground description for this instance.
    ///
    /// If this type has value semantics, the instance returned should be
    /// unaffected by subsequent mutations if possible.
    public var playgroundDescription: Any {
        return self.description
    }
    
}
#else
extension LocalDate: CustomPlaygroundQuickLookable {

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
extension LocalDate: Codable {

    /// A type that can be used as a key for encoding and decoding.
    ///
    /// - year: The year.
    /// - month: The month-of-year.
    /// - day: The day-of-month.
    private enum CodingKeys: Int, CodingKey {
        case year
        case month
        case day
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
    }
}
#endif
