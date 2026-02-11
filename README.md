# SwiftyChronoX

A powerful natural language date and time parser for Swift, supporting multiple languages including English, Spanish, French, German, Japanese, and Chinese (both Simplified and Traditional).

SwiftyChronoX can extract date and time information from natural language text in various formats, making it easy to build applications that understand when users want things to happen.

This project is forked and envolved from:
* Chrono https://github.com/wanasit/chrono
* SwiftyChrono https://github.com/quire-io/SwiftyChrono
* SwiftyChronoSPM https://github.com/harryworld/SwiftyChronoSPM

## Features

- 🌍 **Multi-language Support**: English, Spanish, French, German, Japanese, Chinese (Simplified & Traditional)
- 📅 **Rich Date Parsing**: Casual expressions, relative dates, specific dates, date ranges
- ⏰ **Time Parsing**: Various time formats including 12/24 hour, casual times (morning, tonight, etc.)
- 🔧 **Highly Configurable**: Set preferred languages, implied times, and parsing options
- 🎯 **Context Aware**: Uses reference dates to resolve relative expressions
- 🚀 **Swift Package Manager**: Easy integration into your Swift projects

## Supported Date Formats

SwiftyChronoX can parse a wide variety of date formats including:

- **Casual expressions**: today, tomorrow, yesterday, tonight, last night
- **Relative periods**: last week, next month, this year, past 3 days
- **Time ago**: 5 days ago, 2 weeks ago, 3 months ago
- **Specific dates**: January 15, 2024, 2024-01-15, 15/01/2024
- **Weekdays**: next Monday, last Friday, this Wednesday
- **Date ranges**: from Jan 15 to Jan 20, January 15-20
- **Mixed formats**: tomorrow at 3pm, next Monday morning

## Installation

Use Swift Package Manager

## Quick Start

```swift
import SwiftyChronoX

let chrono = Chrono()
let results = chrono.parse(text: "Let's meet tomorrow at 3pm")

if let result = results.first {
    print(result.start.date) // Date for tomorrow at 3:00 PM
}
```

#### Preferred Language

Setting a preferred language is optional, but it can improve parsing accuracy by reducing false positives from other languages.

```swift
// Option 1: Set per instance
let chrono = Chrono(preferredLanguage: .french)

// Option 2: Set globally for all instances
Chrono.preferredLanguage = .french
```

## Examples

The following examples use a reference date of **January 20, 2026** to demonstrate how SwiftyChronoX resolves relative date expressions.

SwiftyChronoX understands a wide variety of English date and time expressions:

#### Example 1: "today"
```swift
let chrono = Chrono(preferredLanguage: .english)
let refDate = createRefDate(year: 2026, month: 1, day: 20)
let result = chrono.parse(text: "I have a meeting today", refDate: refDate)
// Result: Start date = 2026-01-20
```

#### Example 2: "tomorrow"
```swift
let result = chrono.parse(text: "Let's meet tomorrow", refDate: refDate)
// Result: Start date = 2026-01-21
```

#### Example 3: "yesterday"
```swift
let result = chrono.parse(text: "What happened yesterday?", refDate: refDate)
// Result: Start date = 2026-01-19
```

#### Example 4: "last week"
```swift
let result = chrono.parse(text: "Show spending last week", refDate: refDate)
// Result: Start date = 2026-01-13, End date = 2026-01-19
```

#### Example 5: "next month"
```swift
let result = chrono.parse(text: "Budget for next month", refDate: refDate)
// Result: Start date = 2026-02-01, End date = 2026-02-28
```

#### Example 6: "next year"
```swift
let result = chrono.parse(text: "Planning for next year", refDate: refDate)
// Result: Start date = 2027-01-01, End date = 2027-12-31
```

#### Example 7: "5 days ago"
```swift
let result = chrono.parse(text: "The meeting was 5 days ago", refDate: refDate)
// Result: Start date = 2026-01-15
```

#### Example 8: "2 weeks ago"
```swift
let result = chrono.parse(text: "I bought it 2 weeks ago", refDate: refDate)
// Result: Start date = 2026-01-06
```

#### Example 9: "3 months ago"
```swift
let result = chrono.parse(text: "I subscribed 3 months ago", refDate: refDate)
// Result: Start date = 2025-10-20
```

#### Example 10: "tonight"
```swift
let result = chrono.parse(text: "Let's go out tonight at 10pm", refDate: refDate)
// Result: Start date = 2026-01-20 10:00 PM
```

### Multi-language Support

```swift
let chrono = Chrono(preferredLanguage: .spanish)
let refDate = createRefDate(year: 2026, month: 1, day: 20)
let result = chrono.parse(text: "Tengo una reunión hoy", refDate: refDate)
// Result: Start date = 2026-01-20

let chrono = Chrono(preferredLanguage: .french)
let refDate = createRefDate(year: 2026, month: 1, day: 20)
let result = chrono.parse(text: "On se voit demain", refDate: refDate)
// Result: Start date = 2026-01-21

let chrono = Chrono(preferredLanguage: .german)
let refDate = createRefDate(year: 2026, month: 1, day: 20)
let result = chrono.parse(text: "Was ist gestern passiert?", refDate: refDate)
// Result: Start date = 2026-01-19

let chrono = Chrono(preferredLanguage: .japanese)
let refDate = createRefDate(year: 2026, month: 1, day: 20)
let result = chrono.parse(text: "先週の支出を表示", refDate: refDate)
// Result: Start date = 2026-01-13, End date = 2026-01-19

let chrono = Chrono(preferredLanguage: .chinese)
let refDate = createRefDate(year: 2026, month: 1, day: 20)
let result = chrono.parse(text: "下个月的预算", refDate: refDate)
// Result: Start date = 2026-02-01, End date = 2026-02-28

let result = chrono.parse(text: "明年的計劃", refDate: refDate)
// Result: Start date = 2027-01-01, End date = 2027-12-31
```

---

## Advanced Usage

### Using Reference Dates

Provide a reference date to resolve relative expressions:

```swift
let chrono = Chrono()
let referenceDate = Date() // or any specific date

let results = chrono.parse(
    text: "next Monday",
    refDate: referenceDate
)
```

### Parsing Options

Customize parsing behavior with options:

#### backwardDate Option
```swift
// Reference date: January 20, 2026 (Tuesday)
let refDate = createRefDate(year: 2026, month: 1, day: 20)

// Without backwardDate - "Thursday" refers to the next Thursday
let result1 = chrono.parse(text: "Thursday", refDate: refDate)
// Result: Start date = 2026-01-22 (next Thursday)

// With backwardDate - "Thursday" refers to the previous Thursday
let result2 = chrono.parse(text: "Thursday", refDate: refDate, opt: [.backwardDate: 1])
// Result: Start date = 2026-01-15 (last Thursday)
```

#### forwardDate Option
```swift
// Reference date: January 20, 2026
let refDate = createRefDate(year: 2026, month: 1, day: 20)

// Without forwardDate - "December 1" refers to the previous December
chrono.parseDate(text: "Bring a book on December 1", refDate: refDate)
// Result: Start date = 2025-12-01

// With forwardDate - "December 1" is always later than refDate
chrono.parseDate(text: "Bring a book on December 1", refDate: refDate, opt: [.forwardDate: 1])
// Result: Start date = 2026-12-01
```

#### Customizing Time of Day
```swift
// Reference date: February 1, 2017
let refDate = createRefDate(year: 2017, month: 2, day: 1)

// Assign specific hour for morning, afternoon, evening, noon
chrono.parseDate(text: "Bring a book tomorrow morning", refDate: refDate, opt: [.morning: 10])
// Result: Start date = 2017-02-02 10:00 AM

// Available time period options:
// .morning - customize morning hour (default: 6 AM)
// .afternoon - customize afternoon hour (default: 12 PM)
// .evening - customize evening hour (default: 6 PM)
// .noon - customize noon hour (default: 12 PM)
```

### Working with Results

```swift
let results = chrono.parse(text: "from January 15 to January 20")

if let result = results.first {
    // Start date
    if let startDate = result.start.date {
        print("Start: \(startDate)")
    }

    // End date (for date ranges)
    if let endDate = result.end?.date {
        print("End: \(endDate)")
    }

    // Get specific components
    if let year = result.start.get(.year) {
        print("Year: \(year)")
    }
}
```

### Helper Function for Creating Reference Dates

```swift
func createRefDate(year: Int, month: Int, day: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = 12
    return Calendar(identifier: .gregorian).date(from: components)!
}
```

### Global Configuration

#### Default Implied Time

Customize the default hour, minute, second, and millisecond when not specified in the text:

```swift
// Default behavior (12:00:00.000 PM)
let refDate = createRefDate(year: 2017, month: 1, day: 31)
chrono.parseDate(text: "you can do it tomorrow", refDate: refDate)?.timeIntervalSince1970
// Result: 1485950400.000 (2017-02-01 12:00:00.000 PM)

// Override default implied time
Chrono.defaultImpliedHour = 1
Chrono.defaultImpliedMinute = 1
Chrono.defaultImpliedSecond = 1
Chrono.defaultImpliedMillisecond = 1
chrono.parseDate(text: "you can do it tomorrow", refDate: refDate)?.timeIntervalSince1970
// Result: 1485907261.001 (2017-02-01 01:01:01.001 AM)
```

#### Six Minutes Fix for Dates Before 1900

If your use case involves dates before 1900, enable this fix to handle a calendar discrepancy:

```swift
// Parsing a historical date without the fix
Chrono.sixMinutesFixBefore1900 = false
let date1 = chrono.parseDate(text: "January 1, 1850 at noon")
// Might be: 1850-01-01 11:54:00 (6 minutes off)

// With the fix enabled
Chrono.sixMinutesFixBefore1900 = true
let date2 = chrono.parseDate(text: "January 1, 1850 at noon")
// Will be: 1850-01-01 12:00:00 (correct)
```

## Requirements

- Swift 6.0+
- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
