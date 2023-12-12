/*:
 # Date and Time Calculations in Swift, Part 1
 
 This playground contains all the code in the article in the Auth0 by Okta blog post titled [_Date and Time Calculations in Swift, Part 1_](https://auth0.com/blog/date-time-calculations-swift-1/).
 */


import Cocoa

 /*:
 ## Setup
 
 ### Locale, calendar, and date formatter
 */

// Locale and calendar
var userLocale = Locale.autoupdatingCurrent
var gregorianCalendar = Calendar(identifier: .gregorian)
gregorianCalendar.locale = userLocale

// Date formatter
var dateFormatter = DateFormatter()
dateFormatter.dateStyle = .full
dateFormatter.timeStyle = .full


/*:
 ### Dates
 */

// The original iPhone first made its appearance at about
// 10:03 a.m. (UTC-8) on January 9, 2007.
let iPhoneIntroComponents = DateComponents(
  timeZone: TimeZone(identifier: "America/Los_Angeles"),
  year: 2007,
  month: 1,
  day: 9,
  hour: 10,
  minute: 3
)
let iPhoneIntroDate = gregorianCalendar.date(from: iPhoneIntroComponents)!
let iPhoneIntroDateFormatted = dateFormatter.string(from: iPhoneIntroDate)
print("Introductions:")
print("• The iPhone was introduced to the world on \(iPhoneIntroDateFormatted).")

// Swift first made its appearance at about
// 11:45 a.m. (UTC-7) on June 2, 2014
let swiftIntroDateComponents = DateComponents(
  timeZone: TimeZone(identifier: "America/Los_Angeles"),
  year: 2014,
  month: 6,
  day: 2,
  hour: 11,
  minute: 45
)
let swiftIntroDate = gregorianCalendar.date(from: swiftIntroDateComponents)!
let swiftIntroDateFormatted = dateFormatter.string(from: swiftIntroDate)
print("• Swift was introduced to the world on \(swiftIntroDateFormatted).")

// Apple Silicon first made its appearance at about
// 11:27 a.m. (UTC-7) on June 22, 2020
let appleSiliconIntroDateComponents = DateComponents(
  timeZone: TimeZone(identifier: "America/Los_Angeles"),
  year: 2020,
  month: 6,
  day: 22,
  hour: 11,
  minute: 27
)
let appleSiliconIntroDate = gregorianCalendar.date(from: appleSiliconIntroDateComponents)!
let appleSiliconIntroDateFormatted = dateFormatter.string(from: appleSiliconIntroDate)
print("• Apple Silicon was introduced to the world on \(appleSiliconIntroDateFormatted).")


/*:
 ## Is It Daylight Saving Time in This Time Zone?
 */

let idesOfMarchDateComponents = DateComponents(
  timeZone: TimeZone(secondsFromGMT: 0),
  year: 2024,
  month: 3,
  day: 15,
  hour: 0,
  minute: 0
)
let idesOfMarchDate = gregorianCalendar.date(from: idesOfMarchDateComponents)!
print("\nDaylight Saving Time:")
let pacificTimeZone = TimeZone(identifier: "America/Los_Angeles")!
let isDSTInPacificTimeZone = pacificTimeZone.isDaylightSavingTime(for: idesOfMarchDate)
print("• Is it Daylight Saving Time in the Pacific time zone on March 15, 2024?: \(isDSTInPacificTimeZone)")
let berlinTimeZone = TimeZone(identifier: "Europe/Berlin")!
let isDSTInBerlinTimeZone = berlinTimeZone.isDaylightSavingTime(for: idesOfMarchDate)
print("• Is it Daylight Saving Time in Berlin on March 15, 2024?: \(isDSTInBerlinTimeZone)")


/*:
 ## Comparing Dates
 */

print("\nDate comparisons:")
print("• Swift was announced BEFORE SwiftUI: " +
      "\(swiftIntroDate < appleSiliconIntroDate)")
print("• Swift was announced AFTER SwiftUI: " +
      "\(swiftIntroDate > appleSiliconIntroDate)")
print("• Swift and SwiftUI were announced at the SAME date and time: " +
      "\(swiftIntroDate == appleSiliconIntroDate)")
print("• Swift and SwiftUI were announced at DIFFERENT dates and times: " +
      "\(swiftIntroDate != appleSiliconIntroDate)")


/*:
 ## Sorting Dates
 */

print("\nSince dates can be compared, they can also be sorted:")
let scrambledDates = [
  appleSiliconIntroDate,
  iPhoneIntroDate,
  swiftIntroDate
]
let sortedDates = scrambledDates.sorted()
for date in sortedDates {
  let dateFormatted = dateFormatter.string(from: date)
  print("• \(dateFormatted)")
}


/*:
 ## Date Calculations in Seconds
 */

print("\nIntervals between Dates, in seconds:")
print("• Number of seconds between the Swift and SwiftUI announcements: " +
    "\(swiftIntroDate.timeIntervalSince(appleSiliconIntroDate))")
print("• Number of seconds between the SwiftUI and Swift announcements: " +
    "\(appleSiliconIntroDate.timeIntervalSince(swiftIntroDate))")


/*:
 ### Adding or subtracting seconds to or from a date
 */

let swiftUIIntroDates = [
  "swiftIntroDate"         : swiftIntroDate,
  
  // Adding and subtracting seconds to and from a Date with + and -
  "swiftIntroDate1SecondLater"   : swiftIntroDate + 1,
  "swiftIntroDate1SecondEarlier" : swiftIntroDate - 1,
  
  // Adding and subtracting seconds to and from a Date with addingTimeInterval()
  "swiftIntroDate1MinuteLater"   : swiftIntroDate.addingTimeInterval(60),
  "swiftIntroDate1MinuteEarlier" : swiftIntroDate.addingTimeInterval(-60),
  
  // Adding and subtracting seconds to and from a Date with advanced(by:)
  "swiftIntroDate1HourLater"   : swiftIntroDate.advanced(by: 60 * 60),
  "swiftIntroDate1HourEarlier"   : swiftIntroDate.advanced(by: -60 * 60),
]
for date in swiftUIIntroDates {
  print("• \(date.key): \(date.value.description(with: userLocale))")
}


/*:
 ## Date Calculations in Units That Makes Sense to Us
 
 ### The difference between two dates, in days
 */

print("\nIntervals between Dates, in more convenient units:")

let daysBetweenAnnouncements = gregorianCalendar.dateComponents(
  [.day],
  from: swiftIntroDate,
  to: appleSiliconIntroDate
)
print("• There were \(daysBetweenAnnouncements.day!) days between the introductions of Swift and Apple Silicon.")

/*:
 ### The difference between two dates, in weeks
 */

let weeksBetweenAnnouncements = gregorianCalendar.dateComponents(
  [.weekOfYear],
  from: swiftIntroDate,
  to: appleSiliconIntroDate
)
print("• There were \(weeksBetweenAnnouncements.weekOfYear!) weeks between the introductions of Swift and Apple Silicon.")

/*:
 ### The difference between two dates in years, months, days, hours, and minutes
 */

let ymdhmBetweenAnnouncements = gregorianCalendar.dateComponents(
  [.year, .month, .day, .hour, .minute],
  from: swiftIntroDate,
  to: appleSiliconIntroDate
)
var years = ymdhmBetweenAnnouncements.year!
var months = ymdhmBetweenAnnouncements.month!
var days = ymdhmBetweenAnnouncements.day!
var hours = ymdhmBetweenAnnouncements.hour!
var minutes = ymdhmBetweenAnnouncements.minute!
print("• There were \(years) years, \(months) months, \(days) days, \(hours) hours, and \(minutes) minutes between the introductions of Swift and Apple Silicon.")

// Year-month-date-hours-minutes-seconds components list
let ymdhmsComponentsList: Set = [
  Calendar.Component.year,
  Calendar.Component.month,
  Calendar.Component.day,
  Calendar.Component.hour,
  Calendar.Component.minute,
  Calendar.Component.second
]
let ymdhmsBetweeniPhoneIntroAndNow = gregorianCalendar.dateComponents(
  ymdhmsComponentsList,
  from: iPhoneIntroDate,
  to: Date()
)
print("• ymdhmsBetweeniPhoneIntroAndNow: \(ymdhmsBetweeniPhoneIntroAndNow)")

let ymdhmsBetweenNowAndSwiftIntro = gregorianCalendar.dateComponents(
  ymdhmsComponentsList,
  from: Date(),
  to: swiftIntroDate
)
var seconds: Int
(years, months, days, hours, minutes, seconds) = (
  ymdhmsBetweenNowAndSwiftIntro.year!,
  ymdhmsBetweenNowAndSwiftIntro.month!,
  ymdhmsBetweenNowAndSwiftIntro.day!,
  ymdhmsBetweenNowAndSwiftIntro.hour!,
  ymdhmsBetweenNowAndSwiftIntro.minute!,
  ymdhmsBetweenNowAndSwiftIntro.second!
)
print("• To go to the keynote when Swift was introduced, you’d have to travel \(years) years, \(months) months, \(days) days, \(hours) hours, \(minutes) minutes, and \(seconds) seconds.")

/*:
 ### Adding or subtracting days, weeks, months, and years to or from a date
 */

print("\nAdding and subtracting to and from Dates:")

// I bought something today, and it has a 90-day warranty.
// When does that warranty end?
let ninetyDaysFromNow = gregorianCalendar.date(
  byAdding: .day,
  value: 90,
  to: Date()
)!
dateFormatter.timeStyle = .none
let ninetyDaysFromNowFormatted = dateFormatter.string(from: ninetyDaysFromNow)
print("• 90 days from now is: \(ninetyDaysFromNowFormatted).")

// What was the date five weeks ago?
let fiveWeeksAgo = gregorianCalendar.date(
  byAdding: .weekOfYear,
  value: -5,
  to: Date()
)!
let fiveWeeksAgoFormatted = dateFormatter.string(from: fiveWeeksAgo)
print("• 5 weeks ago was: \(fiveWeeksAgoFormatted).")

// What time will it be 4 hours and 30 minutes from now?
// First, we need to define a DateComponents struct representing
// a time interval of 4 hours and 30 minutes
var fourHoursThirtyMinutes = DateComponents()
fourHoursThirtyMinutes.hour = 4
fourHoursThirtyMinutes.minute = 30

// Now add the interval to the Date
let fourHoursThirtyMinutesFromNow = gregorianCalendar.date(
  byAdding: fourHoursThirtyMinutes,
  to: Date()
)!
dateFormatter.timeStyle = .full
let fourHoursThirtyMinutesFromNowFormatted = dateFormatter.string(from: fourHoursThirtyMinutesFromNow)
print("• 4 hours and 30 minutes from now will be: \(fourHoursThirtyMinutesFromNowFormatted).")

// What time was it 2 years, 17 days, 10 hours and 3 minutes ago?
var pastInterval = DateComponents()
pastInterval.year = -2
pastInterval.day = -17
pastInterval.hour = -10
pastInterval.minute = -3
let pastDate = gregorianCalendar.date(
  byAdding: pastInterval,
  to: Date()
)!
let pastDateFormatted = dateFormatter.string(from:pastDate)
print("• 2 years, 17 days, 10 hours and 3 minutes ago was: \(pastDateFormatted).")


/*:
 ## Date Comparisons That Feel More “Human”
 */

print("\nMore “human” Date comparisons:")

// Technically speaking, these two dates and times are different:
// - the date and time when Apple Silicon made its first public appearance
// - one second afterward
// ...are two different dates and times
let appleSiliconIntroDatePlus1Second = appleSiliconIntroDate + 1
print("• appleSiliconIntroDate == appleSiliconIntroDatePlus1Second: " +
    "\(appleSiliconIntroDate == appleSiliconIntroDatePlus1Second)")

// Defining a couple of extra dates for later comparison:
// - 5 minutes after the first public appearance of Apple Silicon
// - 3 hours after the first public appearance of Apple Silicon
let appleSiliconIntroDatePlus5Minutes = gregorianCalendar.date(
  byAdding: .minute,
  value: 5,
  to: appleSiliconIntroDate
)!
let appleSiliconIntroDatePlus3Hours = gregorianCalendar.date(
  byAdding: .hour,
  value: 3,
  to: appleSiliconIntroDate
)!

// At the .second level of granularity,
// appleSiliconIntroDate != appleSiliconIntroDatePlus1Second
let test1 = gregorianCalendar.compare(
  appleSiliconIntroDate,
  to: appleSiliconIntroDatePlus1Second,
  toGranularity: .second
) == .orderedSame
print("• appleSiliconIntroDate == appleSiliconIntroDatePlus1Second (with second granularity): \(test1)")

// At the .second level of granularity,
// appleSiliconIntroDate < appleSiliconIntroDatePlus1Second
let test2 = gregorianCalendar.compare(
  appleSiliconIntroDate,
  to: appleSiliconIntroDatePlus1Second,
  toGranularity: .second
) == .orderedAscending
print("• appleSiliconIntroDate < appleSiliconIntroDatePlus1Second (with second granularity): \(test2)")

// At the .minute level of granularity,
// appleSiliconIntroDate == appleSiliconIntroDatePlus1Second
let test3 = gregorianCalendar.compare(
  appleSiliconIntroDate,
  to: appleSiliconIntroDatePlus1Second,
  toGranularity: .minute
) == .orderedSame
print("• appleSiliconIntroDate == appleSiliconIntroDatePlus1Second (with minute granularity): \(test3)")

// At the .minute level of granularity,
// appleSiliconIntroDatePlus5Minutes > appleSiliconIntroDate
let test4 = gregorianCalendar.compare(
  appleSiliconIntroDatePlus5Minutes,
  to: appleSiliconIntroDate,
  toGranularity: .minute
) == .orderedDescending
print("• appleSiliconIntroDatePlus5Minutes > appleSiliconIntroDate (with minute granularity): \(test4)")

// At the .hour level of granularity,
// appleSiliconIntroDate == appleSiliconIntroDatePlus5Minutes
let test5 = gregorianCalendar.compare(
  appleSiliconIntroDate,
  to: appleSiliconIntroDatePlus5Minutes,
  toGranularity: .hour
) == .orderedSame
print("• appleSiliconIntroDate == appleSiliconIntroDatePlus5Minutes (with hour granularity): \(test5)")

// At the .day level of granularity,
// appleSiliconIntroDate == appleSiliconIntroDatePlus3Hours
let test6 = gregorianCalendar.compare(
  appleSiliconIntroDate,
  to: appleSiliconIntroDatePlus3Hours,
  toGranularity: .day
) == .orderedSame
print("• appleSiliconIntroDate == appleSiliconIntroDatePlus3Hours (with day granularity): \(test6)")


/*:
 ## Calculating “Next Dates”
 */

// When is the next time it will be 3:00 a.m.?
print("\nNext Dates:")
let next3AmComponents = DateComponents(hour: 3)
let next3AmDate = gregorianCalendar.nextDate(
  after: Date(),
  matching: next3AmComponents,
  matchingPolicy: .nextTime
)!
let next3AmFormatted = dateFormatter.string(from: next3AmDate)
print("• The next time it will be 3:00 a.m. is: \(next3AmFormatted).")

// When are the dates of:
// - The previous Sunday?
// - Next Sunday?
let sundayComponents = DateComponents(
  weekday: 1
)
let previousSunday = gregorianCalendar.nextDate(
  after: Date(),
  matching: sundayComponents,
  matchingPolicy: .nextTime,
  direction: .backward
)!
let nextSunday = gregorianCalendar.nextDate(
  after: Date(),
  matching: sundayComponents,
  matchingPolicy: .nextTime,
  direction: .forward
)!
dateFormatter.timeStyle = .none
let previousSundayFormatted = dateFormatter.string(from: previousSunday)
let nextSundayFormatted = dateFormatter.string(from: nextSunday)
print("• The previous Sunday was \(previousSundayFormatted).")
print("• The next Sunday will be \(nextSundayFormatted).")

// When is the next “third Friday of the month?”
let nextThirdFridayComponents = DateComponents(
  weekday: 6,
  weekdayOrdinal: 3
)
let nextThirdFridayDate = gregorianCalendar.nextDate(
  after: Date(),
  matching: nextThirdFridayComponents,
  matchingPolicy: .nextTime
)!
let nextThirdFridayFormatted = dateFormatter.string(from: nextThirdFridayDate)
print("• The next third Friday of the month will be \(nextThirdFridayFormatted).")

/*:
 ### When is the next unlucky day?
 */

print("\nUnlucky days:")

// When is the next Friday the 13th, an unlucky day in many western cultures?
let friday13thComponents = DateComponents(
  day: 13,
  weekday: 6)
let nextFriday13thDate = gregorianCalendar.nextDate(
  after: Date(),
  matching: friday13thComponents,
  matchingPolicy: .nextTime
)!
let nextFriday13thFormatted = dateFormatter.string(from: nextFriday13thDate)
print("• The next Friday the 13th will be on \(nextFriday13thFormatted).")

// When is the next Tuesday the 13th, an unlucky day in Spain?
let tuesday13thComponents = DateComponents(
  day: 13,
  weekday: 3)
let nexttuesday13thDate = gregorianCalendar.nextDate(
  after: Date(),
  matching: tuesday13thComponents,
  matchingPolicy: .nextTime
)!
let nexttuesday13thFormatted = dateFormatter.string(from: nexttuesday13thDate)
print("• The next Tuesday the 13th will be on \(nexttuesday13thFormatted).")

// When is the next Friday the 17th, an unlucky day in Italy?
let friday17thComponents = DateComponents(
  day: 17,
  weekday: 6)
let nextFriday17thDate = gregorianCalendar.nextDate(
  after: Date(),
  matching: friday17thComponents,
  matchingPolicy: .nextTime
)!
let nextFriday17thFormatted = dateFormatter.string(from: nextFriday17thDate)
print("• The next Friday the 17th will be on \(nextFriday17thFormatted).")


/*:
 ## Enumerating Specific Dates
 */

// This function returns the dates for all the Friday the 13ths in a given year.
func fridayThe13ths(inYear year: Int) -> [Date] {
  var result: [Date] = []
  let startingDateComponents = DateComponents(year: year)
  let startingDate = gregorianCalendar.date(from: startingDateComponents)!
  
  gregorianCalendar.enumerateDates(
    startingAfter: startingDate,
    matching: friday13thComponents,
    matchingPolicy: .nextTime
  ) { (date, strict, stop) in
    if let validDate = date {
      let dateComponents = gregorianCalendar.dateComponents(
        [.year],
        from: validDate
      )
      if dateComponents.year! > year {
        stop = true
      } else {
        result.append(validDate)
      }
    }
  }
  
  return result
}

print("\n👻 Here are the Friday the 13ths for 2024:")
for fridayThe13th in fridayThe13ths(inYear: 2024) {
  let fridayThe13thFormatted = dateFormatter.string(from: fridayThe13th)
  print("• \(fridayThe13thFormatted)")
}
