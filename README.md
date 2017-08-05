# AnyDate

![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CI Status](https://travis-ci.org/Kawoou/AnyDate.svg?branch=master)](https://travis-ci.org/Kawoou/AnyDate)
[![Version](https://img.shields.io/cocoapods/v/AnyDate.svg?style=flat)](http://cocoadocs.org/docsets/AnyDate)
[![License](https://img.shields.io/cocoapods/l/AnyDate.svg?style=flat)](https://github.com/kawoou/AnyDate/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/AnyDate.svg?style=flat)](http://cocoadocs.org/docsets/AnyDate)
[![Codecov](https://img.shields.io/codecov/c/github/Kawoou/AnyDate.svg)](https://codecov.io/gh/Kawoou/AnyDate)

I think that dates and time-zones management should be easy and accurate.
However, in Swift's were very complex, and some issues such as:
 - Inability to handle accurate nanoseconds.
   * Test Case '-[AnyDateTests.ClockTests testToTimeZone]'
 - Many parts are Nullable.

Since Java 8, the new class for that more efficient and easier to use time management has been added(JSR-310): That's LocalDateTime, ZonedDateTime, and so on.
Core ideas is Immutable-value classes, Domain-driven design, Separation of chronologies.

So I wanted to implement that uses Java a coherence as similarly ReactiveX.



## Features

* [x] Easily work with time components.
* [x] Easy conversions to and from timezone.
* [x] Immutable-value classes.
* [x] Separation of chronologies.
* [x] Coherence with Java.
* [x] Compare dates with math operators.
* [ ] Simple component operations for the date.
* [ ] Support period class for time.



## Installation

### [CocoaPods](https://cocoapods.org)

```ruby
pod 'AnyDate', '~> 1.0.0'
```

### [Carthage](https://github.com/Carthage/Carthage)

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





