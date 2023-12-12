/*:
 # Date and Time Calculations in Swift, Part 2
 
 This playground contains all the code in the article in the Auth0 by Okta blog post titled [_Date and Time Calculations in Swift, Part 2_](https://auth0.com/blog/date-time-calculations-swift-2/).
 */


import Cocoa

/*:
## Let’s Make Date Calculations in Swift More Elegant
 */

// Locale, calendar, and date formatter
var userLocale = Locale.autoupdatingCurrent
var gregorianCalendar = Calendar(identifier: .gregorian)
gregorianCalendar.locale = userLocale
let dateFormatter = DateFormatter()

// Time interval of 2 months, 3 days, 4 hours, 
// 5 minutes, and 6 seconds
var timeInterval = DateComponents(
  month: 2,
  day: 3,
  hour: 4,
  minute: 5,
  second: 6
)
let futureDate = gregorianCalendar.date(
    byAdding: timeInterval,
    to: Date()
)!
print("\n2 months, 3 days, 4 hours, 5 minutes, and 6 seconds from now is \(futureDate.description).")


/*:
 ## Extending Date for Simpler Date Creation and Debugging
 */

extension Date {
    
    // 1
    init(
        year: Int,
        month: Int,
        day: Int,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        timeZoneIdentifier: String = "UTC"
    ) {
        let components = DateComponents(
            timeZone: TimeZone(identifier: timeZoneIdentifier),
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )
        self = Calendar(identifier: .gregorian).date(from: components)!
    }
    
    // 2
    init(
        year: Int,
        month: Int,
        day: Int,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        timeZoneAbbreviation: String = "UTC"
    ) {
        let components = DateComponents(
            timeZone: TimeZone(abbreviation: timeZoneAbbreviation),
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )
        self = Calendar(identifier: .gregorian).date(from: components)!
    }
    
    // 3
    init(iso8601Date: String) {
        self = ISO8601DateFormatter().date(from: iso8601Date)!
    }
    
    // 4
    var desc: String {
      get {
        let PREFERRED_LOCALE = "en_US" // Use whatever locale you prefer!
        return self.description(with: Locale(identifier: PREFERRED_LOCALE))
      }
    }
}

// Creating dates with these new initializers
print("Dates:")

// The moment that Steve Jobs told MacWorld 2007 attendees that their
// new “iPod, phone, and internet communicator” was one thing,
// and it was called the iPhone: January 9, 2007, 10:03 a.m. PST.
let iPhoneIntroDate = Date(
    year: 2007,
    month: 01,
    day: 09,
    hour: 10,
    minute: 3,
    timeZoneIdentifier: "America/Los_Angeles"
)
print("• iPhoneIntroDate: \(iPhoneIntroDate.desc)")

// The moment when the Swift programming language was announced
// at WWDC 2014: June 2, 2014, 11:45 PDT.
let swiftIntroDate = Date(
    year: 2014,
    month: 06,
    day: 02,
    hour: 11,
    minute: 45,
    timeZoneAbbreviation: "PDT"
)
print("• swiftIntroDate: \(swiftIntroDate.desc)")

// The moment when Apple Silicon was announced at a special
// WWDC online event: June 22, 2020, 11:27 a.m. PDT.
let appleSiliconIntroDate = Date(iso8601Date: "2020-06-22T11:27:00-07:00")
print("• appleSiliconIntroDate: \(appleSiliconIntroDate.desc)")


/*:
 ## Overloading “+” And “-” For Date and Time Calculations
 
 ### Adding and Subtracting DateComponents
 */

// The overloads of “+” and “-” rely on this function
func combineComponents(
  _ lhs: DateComponents,
  _ rhs: DateComponents,
  multiplier: Int = 1
) -> DateComponents {
  var result = DateComponents()
  result.nanosecond = (lhs.nanosecond ?? 0) + (rhs.nanosecond ?? 0) * multiplier
  result.second     = (lhs.second     ?? 0) + (rhs.second     ?? 0) * multiplier
  result.minute     = (lhs.minute     ?? 0) + (rhs.minute     ?? 0) * multiplier
  result.hour       = (lhs.hour       ?? 0) + (rhs.hour       ?? 0) * multiplier
  result.day        = (lhs.day        ?? 0) + (rhs.day        ?? 0) * multiplier
  result.weekOfYear = (lhs.weekOfYear ?? 0) + (rhs.weekOfYear ?? 0) * multiplier
  result.month      = (lhs.month      ?? 0) + (rhs.month      ?? 0) * multiplier
  result.year       = (lhs.year       ?? 0) + (rhs.year       ?? 0) * multiplier
  return result
}

// Overload “+” so that you can use it to calculate
// DateComponents + DateComponents
func +(_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
  return combineComponents(lhs, rhs)
}

// Overload “-” so that you can use it to calculate
// DateComponents - DateComponents
func -(_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
  return combineComponents(lhs, rhs, multiplier: -1)
}

// Testing the “+” and “-” overloads
let threeDaysTenHoursThirtyMinutes = DateComponents(
  day: 3,
  hour: 10,
  minute: 30
)
let oneDayFiveHoursTenMinutes = DateComponents(
  day: 1,
  hour: 5,
  minute: 10
)

print("\nOverloaded + and - for DateComponents:")

// 3 days, 10 hours, and 30 minutes + 1 day, 5 hours, and 10 minutes
let additionResult = threeDaysTenHoursThirtyMinutes + oneDayFiveHoursTenMinutes
print("• 3 days, 10 hours, and 30 minutes + 1 day, 5 hours, and 10 minutes = \(additionResult.day!) days, \(additionResult.hour!) hours, and \(additionResult.minute!) minutes.")

// 3 days, 10 hours, and 30 minutes - 1 day, 5 hours, and 10 minutes
let subtractionResult = threeDaysTenHoursThirtyMinutes - oneDayFiveHoursTenMinutes
print("• 3 days, 10 hours, and 30 minutes - 1 day, 5 hours, and 10 minutes = \(subtractionResult.day!) days, \(subtractionResult.hour!) hours, and \(subtractionResult.minute!) minutes.")

/*:
 ### Negating DateComponents
 */

// Overload unary “-” so that you negate DateComponents
prefix func -(components: DateComponents) -> DateComponents {
  var result = DateComponents()
  if components.nanosecond != nil { result.nanosecond = -components.nanosecond! }
  if components.second   != nil { result.second   = -components.second! }
  if components.minute   != nil { result.minute   = -components.minute! }
  if components.hour   != nil { result.hour   = -components.hour! }
  if components.day  != nil { result.day  = -components.day! }
  if components.weekOfYear != nil { result.weekOfYear = -components.weekOfYear! }
  if components.month  != nil { result.month  = -components.month! }
  if components.year   != nil { result.year   = -components.year! }
  return result
}

// Testing the unary “-” overload
// - (1 day, 5 hours, and 10 minutes)
print("\nOverloaded unary - for DateComponents:")
let negativeTime = -oneDayFiveHoursTenMinutes
print("• Negating 1 day, 5 hours, and 10 minutes turns it into \(negativeTime.day!) days, \(negativeTime.hour!) hours, and \(negativeTime.minute!) minutes.")

/*:
 ### Adding and Subtracting Dates and DateComponents
 */

// Overload “+” so that you can use it to calculate
// Date + DateComponents
func +(_ lhs: Date, _ rhs: DateComponents) -> Date
{
  return Calendar.current.date(byAdding: rhs, to: lhs)!
}

// Overload “+” so that you can use it to calculate
// DateComponents + Dates
func +(_ lhs: DateComponents, _ rhs: Date) -> Date
{
  return rhs + lhs
}

// Overload “-” so that you can use it to calculate
// Date - DateComponents
func -(_ lhs: Date, _ rhs: DateComponents) -> Date
{
  return lhs + (-rhs)
}

// What time will it be 1 day, 5 hours, and 10 minutes from now?
print("\nOverloaded + and - for Date/DateComponent calculations:")

// Here's the standard way of finding out:
let futureDate0 = Calendar.current.date(
  byAdding: oneDayFiveHoursTenMinutes,
  to: Date()
)

// With our overloads and function definitions, we can now do it this way:
print("• Date() + oneDayFiveHoursTenMinutes = \((Date() + oneDayFiveHoursTenMinutes).desc).")

// This will work as well:
print("• oneDayFiveHoursTenMinutes + Date() = \((oneDayFiveHoursTenMinutes + Date()).desc).")

// Let’s see subtraction in action:
print("• Date() - threeDaysTenHoursThirtyMinutes = \((Date() - threeDaysTenHoursThirtyMinutes).desc).")

/*:
 ### Calculating the Difference between Two Dates
 */

func -(_ lhs: Date, _ rhs: Date) -> DateComponents
{
  return Calendar.current.dateComponents(
    [.year, .month, .weekOfYear, .day, .hour, .minute, .second, .nanosecond],
    from: rhs,
    to: lhs)
}

print("\nOverloaded - for Date subtraction:")

// What’s the time difference between:
// - The date Apple Silicon was introduced (June 22, 2020, 11:27 a.m. UTC-7) and
// - The date the iPhone was introduced (January 9, 2007, 10:03 a.m. UTC-8)?
let introInterval = appleSiliconIntroDate - iPhoneIntroDate
print("• The interval between the introduction of the iPhone and the introduction of Apple Silicon is \(introInterval.year!) years, \(introInterval.month!) months, \(introInterval.day!) days, \(introInterval.hour!) hours, and \(introInterval.minute!) minutes.")


/*:
 ## Adding Syntactic Magic to DateComponents
 
 ### Extending Int to Make DateComponent Creation More Readable
 */

extension Int {

  var second: DateComponents {
    var components = DateComponents()
    components.second = self;
    return components
  }
  
  var seconds: DateComponents {
    return self.second
  }
  
  var minute: DateComponents {
    var components = DateComponents()
    components.minute = self;
    return components
  }
  
  var minutes: DateComponents {
    return self.minute
  }
  
  var hour: DateComponents {
    var components = DateComponents()
    components.hour = self;
    return components
  }
  
  var hours: DateComponents {
    return self.hour
  }
  
  var day: DateComponents {
    var components = DateComponents()
    components.day = self;
    return components
  }
  
  var days: DateComponents {
    return self.day
  }
  
  var week: DateComponents {
    var components = DateComponents()
    components.weekOfYear = self;
    return components
  }
  
  var weeks: DateComponents {
    return self.week
  }
  
  var month: DateComponents {
    var components = DateComponents()
    components.month = self;
    return components
  }
  
  var months: DateComponents {
    return self.month
  }
  
  var year: DateComponents {
    var components = DateComponents()
    components.year = self;
    return components
  }
  
  var years: DateComponents {
    return self.year
  }
  
}

// A quick test of some future dates
print("One hour from now is: \((Date() + 1.hour).desc)")
print("One day from now is: \((Date() + 1.day).desc)")
print("One week from now is: \((Date() + 1.week).desc)")
print("One month from now is: \((Date() + 1.month).desc)")
print("One year from now is: \((Date() + 1.year).desc)")

// What was the date 10 years, 9 months, 8 days, 7 hours, and 6 minutes ago?
let aLittleWhileBack = Date() - 10.years - 9.months - 8.days - 7.hours - 6.minutes
print("10 years, 9 months, 8 days, 7 hours, and 6 minutes ago, it was: \(aLittleWhileBack.desc)")

/*:
 ### Adding Even More Syntactic Magic with “fromNow” And “ago”
 */

extension DateComponents {
  
  var fromNow: Date {
    return Calendar.current.date(
        byAdding: self,
        to: Date()
    )!
  }
  
  var ago: Date {
    return Calendar.current.date(
        byAdding: -self,
        to: Date()
    )!
  }
  
}

// Test “fromNow” and “ago”
print("\nSome serious syntactic magic:")
print("• 2.weeks.fromNow: \(2.weeks.fromNow.desc)")
print("• 3.months.fromNow: \(3.months.fromNow.desc)")

// What date/time will it be 2 months, 3 days, 4 hours,
// 5 minutes, and 6 seconds from now?
let futureDate3 = (2.months + 3.days + 4.hours + 5.minutes + 6.seconds).fromNow
print("• (2.months + 3.days + 4.hours + 5.minutes + 6.seconds).fromNow: \(futureDate3.desc).")

// What date/time was it 2 months, 3 days, 4 hours,
// 5 minutes, and 6 seconds ago?
let pastDate2 = (2.months + 3.days + 4.hours + 5.minutes + 6.seconds).ago
print("• (2.months + 3.days + 4.hours + 5.minutes + 6.seconds).ago: \(pastDate2.desc)")
