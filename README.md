# AnyDate

![Swift](https://img.shields.io/badge/Swift-3.1-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CI Status](https://travis-ci.org/Kawoou/AnyDate.svg?branch=master)](https://travis-ci.org/Kawoou/AnyDate)
[![Version](https://img.shields.io/cocoapods/v/AnyDate.svg?style=flat)](http://cocoadocs.org/docsets/AnyDate)
[![License](https://img.shields.io/cocoapods/l/AnyDate.svg?style=flat)](https://github.com/kawoou/AnyDate/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/AnyDate.svg?style=flat)](http://cocoadocs.org/docsets/AnyDate)
[![Codecov](https://img.shields.io/codecov/c/github/Kawoou/AnyDate.svg)](https://codecov.io/gh/Kawoou/AnyDate)

Swift Date & Time API inspired from Java 8 DateTime API.


## Background

I think that date & time API should be easy and accurate.

Previous dates, times, timezones API of Swift are inconvenience to use. (It's very complex to create, manipulate or everything else.)

But there's quite nice pioneer, ***The Brand New Time API of Java8***.

Java 8 introduced whole new API for handle date & time more efficiently and easy a.k.a LocalDateTime, ZonedDateTime(JSR-310). The main idea that is:

* Immutable-value classes
* Domain-driven design
* Separation of chronologies

Those ideas can be easily ported to another languages, like .Net's Rx ports of another languages.



So, here's the AnyDate, whole new Swift date & time API that has coherence between Java 8.




## Features

* [x] Easily work with time components.
* [x] Easy conversions to and from timezone.
* [x] Immutable-value classes.
* [x] Separation of chronologies.
* [x] Coherence with Java.
* [x] Compare dates with math operators.
* [x] Simple component operations for the date.
* [x] Support period class for time.




## FAQ

* Looks like SwiftDate?
  - SwiftDate is a support library for Date, AnyDate can completely replace Date.




## Usage

* Convinience typed year, month, day, time.

```swift
/// Before
let now1 = Date()
var calendar = Calendar.current
calendar.timeZone = TimeZone(identifier: "UTC")!

let day = calendar.components(.day, from: now1)

/// After
let now2 = ZonedDateTime(Clock.utc)
let day = now2.day
```

* Pre-defined Timezone Identifiers. String typed timezones are not safe from your *TYPING ERROR*. (Plz, do not belive your finger. They can always betray you.)

```swift
/// Before
let timeZone1 = TimeZone(identifier: "GMT+0900")!
let timeZone2 = TimeZone(identifier: "America/Argentina/Buenos_Aires")!

/// After
let clock1 = Clock(offsetHour: 9)
let clock2 = Clock(identifier: .americaArgentinaBuenosAires)
```

* Null-Safe types. ***NO MORE NEEDLESS GUARD & OPTIONAL AND INDENT INCRESEMENT :-D***

```swift
/// Before
var dateComponents = DateComponents()
dateComponents.year = 2000
dateComponents.month = 11
dateComponents.day = 30
dateComponents.hour = 11
dateComponents.minute = 51
dateComponents.second = 18
dateComponents.nanosecond = 1573

guard let date = Calendar.current.date(from: dateComponents) else {
    assertionFailure("Failed to create!")
    return
}

/// After
let date = LocalDateTime(
    year: 2000,
    month: 11,
    day: 30,
    hour: 11,
    minute: 51,
    second: 18,
    nanoOfSecond: 1573
)
```

* Operators supported. Easy to compare dates, datetimes, times.

```swift
let min = ZonedDateTime.min
let max = ZonedDateTime.max

let oldDate = ZonedDateTime(year: 1627, month: 2, day: 10, hour: 14, minute: 2, second: 18, nanoOfSecond: 1573, clock: .UTC)
let newDate = ZonedDateTime(year: 1627, month: 2, day: 10, hour: 14, minute: 2, second: 18, nanoOfSecond: 1574, clock: .UTC)
let equalDate = ZonedDateTime(year: 1627, month: 2, day: 10, hour: 14, minute: 2, second: 18, nanoOfSecond: 1573, clock: .UTC)

let isLessThan = min < oldDate
let isGreaterThan = max > newDate
let isLessThanOrEqual = oldDate <= equalDate
let isGreaterThanOrEqual = oldDate >= equalDate
let isEqual = oldDate == equalDate
let isLessThan = oldDate < newDate
```

* Easy to manipulate. You can use our overridden operators to create / add / sub dates and times.

```swift
/// 1000-01-07T11:51:18.157300000
let date = LocalDateTime(
    year: 1000,
    month: 1,
    day: 7,
    hour: 11,
    minute: 51,
    second: 18,
    nanoOfSecond: 1573
)
print(date)

/// Period(year: 1, month: 1, day: 9, hour: 2, minute: 3, second: 4, nano: 152)
let period = 1.year + 1.month + 1.week + 2.day + 2.hour + 3.minute + 4.second + 152.nanosecond

/// 1001-03-16T13:54:22.172500000
let newDate = date + period
print(newDate)
```



## Installation

### [CocoaPods](https://cocoapods.org):

```ruby
pod 'AnyDate', '~> 1.0.0'
```

### [Carthage](https://github.com/Carthage/Carthage):

```
github "Kawoou/AnyDate" ~> 1.0.0
```

### [Swift Package Manager](https://swift.org/package-manager):

```swift
import PackageDescription

let package = Package(
  name: "MyAwesomeApp",
  dependencies: [
    .Package(url: "https://github.com/Kawoou/AnyDate", majorVersion: 1),
  ]
)
```

### Manually

You can either simply drag and drop the `Sources` folder into your existing project.



## Requirements

* Swift 3.1
* iOS 8.0+
* tvOS 9.0+
* macOS 10.10+
* watchOS 2.0+
* Virtually any platform which is compatible with Swift 3 and implements the Swift Foundation Library.




## Changelog

* 1.0.0 - 2017-08-13
   * First release AnyDate!




## Author

* kawoou, [kawoou@kawoou.kr](mailto:kawoou@kawoou.kr)
* dave, [dave.dev@icloud.com](mailto:dave.dev@icloud.com)



## Special Thanks

* Naming by 아메바



## License

AnyDate is under MIT license. See the LICENSE file for more info.





