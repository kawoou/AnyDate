# AnyDate

![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CI Status](https://travis-ci.org/Kawoou/AnyDate.svg?branch=master)](https://travis-ci.org/Kawoou/AnyDate)
[![Version](https://img.shields.io/cocoapods/v/AnyDate.svg?style=flat)](http://cocoadocs.org/docsets/AnyDate)
[![License](https://img.shields.io/cocoapods/l/AnyDate.svg?style=flat)](https://github.com/kawoou/AnyDate/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/AnyDate.svg?style=flat)](http://cocoadocs.org/docsets/AnyDate)
[![Codecov](https://img.shields.io/codecov/c/github/Kawoou/AnyDate.svg)](https://codecov.io/gh/Kawoou/AnyDate)



## Background

I think that dates and time-zones management should be easy and accurate.
However, In Swift, it is very complex to manage dates and time-zones. also, it has some issues such as:

- Inability to handle accurate nanoseconds.
   * Test Case '-[AnyDateTests.ZonedDateTimeTests testToDate]'

Java 8 introduced the new class for time management more efficiently and easily a.k.a LocalDateTime, ZonedDateTime(JSR-310). The main idea that is:

* Immutable-value classes
* Domain-driven design
* Separation of chronologies

I intend to make a coherence between Java as a ReactiveX.



## Features

* [x] Easily work with time components.
* [x] Easy conversions to and from timezone.
* [x] Immutable-value classes.
* [x] Separation of chronologies.
* [x] Coherence with Java.
* [x] Compare dates with math operators.
* [ ] Simple component operations for the date.
* [ ] Support period class for time.




## Usage

### Clock

* Simple to use timezone offset.

```swift
/// Before
let timeZone = TimeZone(identifier: "GMT+0900") 

/// After
let clock = Clock(offsetHour: 9)
```

* Safe timezone identifier.

```swift
/// Before
let timeZone = TimeZone(identifier: "America/Argentina/Buenos_Aires")

/// After
let clock = Clock(identifier: .americaArgentinaBuenosAires)
```

* Short code.

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

* Safe Optional.

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

* Swift 3
* iOS 8.0+
* tvOS 9.0+
* macOS 10.10+
* watchOS 2.0+
* Virtually any platform which is compatible with Swift 3 and implements the Swift Foundation Library.




## Changelog

* 1.0.0 - 2017-08-xx
   * First release AnyDate!




## License

AnyDate is under MIT license. See the LICENSE file for more info.





