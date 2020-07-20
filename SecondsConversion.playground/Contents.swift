import UIKit
import XCTest

var str = "Hello, playground"

// Input: Hours minutes seconds string
// "hh:mm:ss"
// "ss"
// Output: number of seconds

enum Time {
    case seconds(Double)
    case minutes(Double)
    case hours(Double)
    func convertToSeconds() -> TimeInterval {
        switch self {
        case let .seconds(val):
            return val
        case let .minutes(val):
            return val * 60
        case let .hours(val):
            return val * 60 * 60
        }
    }
}

func convertTimeStrToSeconds(_ str: String) -> TimeInterval {
    let timeComponents = str.components(separatedBy: ":")
    var totalSeconds: TimeInterval = 0
    for (timeUnitIndex, value) in timeComponents.reversed().enumerated() {
        let time: Time
        guard let timeValue = Double(value) else { fatalError("Unexpected input format: \(str)")}
        switch timeUnitIndex {
        case 0: time = .seconds(timeValue)
        case 1: time = .minutes(timeValue)
        case 2: time = .hours(timeValue)
        default: fatalError("Unexpected input format: \(str)")
        }
        totalSeconds += time.convertToSeconds()
    }
    return totalSeconds
}

let testStrOne = "36"
XCTAssertEqual(convertTimeStrToSeconds(testStrOne), 36)

let testStrTwo = "18:13"
XCTAssertEqual(convertTimeStrToSeconds(testStrTwo), 1093)

let testStrThree = "02:55:38"
XCTAssertEqual(convertTimeStrToSeconds(testStrThree), 10538)

func convertTimeStrToSeconds2(_ str: String) -> TimeInterval {
    let formatter = DateFormatter()
    let formatStr: String
    switch str.components(separatedBy: ":").count {
    case 1: formatStr = "ss"
    case 2: formatStr = "mm:ss"
    case 3: formatStr = "HH:mm:ss"
    default: fatalError("Bad input format")
    }
    formatter.dateFormat = formatStr
    guard let date = formatter.date(from: str) else { fatalError() }
    let zeroTimeDate = DateComponents(calendar: Calendar.current,
                                      year: 2000,
                                      month: 1,
                                      day: 1).date!
    let timeElapsed = date.timeIntervalSince(zeroTimeDate)
    return timeElapsed
}

10_000 / 2
1 / 5_000

convertTimeStrToSeconds2("02:55:38")

class DateFormatterService {
    private init() {}

    static let manager = DateFormatterService()

    private let dateFormatter = DateFormatter()

    func date(usingDateFormat dateFormat: String, dateStr: String) -> Date {
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateStr)!
    }
}

extension Date {
    static func convertTimeStrToSeconds(_ str: String) -> TimeInterval {
        let formatter = DateFormatter()
        let formatStr: String
        switch str.components(separatedBy: ":").count {
        case 1: formatStr = "ss"
        case 2: formatStr = "mm:ss"
        case 3: formatStr = "HH:mm:ss"
        default: fatalError("Bad input format")
        }
        formatter.dateFormat = formatStr
        guard let date = formatter.date(from: str) else { fatalError() }
        let zeroTimeDate = DateComponents(calendar: Calendar.current,
                                          year: 2000,
                                          month: 1,
                                          day: 1).date!
        let timeElapsed = date.timeIntervalSince(zeroTimeDate)
        return timeElapsed
    }
    static func convertTimeStrToSecondsUsingSingletonFormatter(_ str: String) -> TimeInterval {
        let formatStr: String
        switch str.components(separatedBy: ":").count {
        case 1: formatStr = "ss"
        case 2: formatStr = "mm:ss"
        case 3: formatStr = "HH:mm:ss"
        default: fatalError("Bad input format")
        }
        let date = DateFormatterService.manager.date(usingDateFormat: formatStr, dateStr: str)
        let zeroTimeDate = DateComponents(calendar: Calendar.current,
                                          year: 2000,
                                          month: 1,
                                          day: 1).date!
        let timeElapsed = date.timeIntervalSince(zeroTimeDate)
        return timeElapsed
    }
}

Date.convertTimeStrToSeconds("23:32:30")

print("Benchmarking building formatter once in our singleton")
let startTime2 = Date()
for _ in 0...100_000 {
    Date.convertTimeStrToSecondsUsingSingletonFormatter("\(Int.random(in: 10..<24)):\(Int.random(in: 10..<60)):\(Int.random(in: 10..<60))")
}

let endTime2 = Date()
print("Time: \(startTime2.distance(to: endTime2))")

print("Benchmarking no formatter ")
let startTime3 = Date()
for _ in 0...100_000 {
    convertTimeStrToSeconds("\(Int.random(in: 10..<24)):\(Int.random(in: 10..<60)):\(Int.random(in: 10..<60))")
}

let endTime3 = Date()
print("Time: \(startTime3.distance(to: endTime3))")


print("Benchmarking building formatter n times")
let startTime1 = Date()
for _ in 0...100_000 {
    let str = "\(Int.random(in: 10..<24)):\(Int.random(in: 10..<60)):\(Int.random(in: 10..<60))"
    //print(str)
    Date.convertTimeStrToSeconds(str)
}
let endTime1 = Date()
print("Time: \(startTime1.distance(to: endTime1))")



