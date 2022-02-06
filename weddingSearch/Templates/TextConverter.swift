//
//  TextConverter.swift
//  TeacherMatching
//
//  Created by Tenna on R 3/05/13.
//

import Foundation

class TextConverter {
    
    static func price(_ price: Int, considerFree: Bool = true) -> String {
        if price == 0, considerFree { return "無料" }
        else {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            guard let formattedPriceString = numberFormatter.string(from: NSNumber(value: price)) else {
                return "N/A"
            }
            return "\(formattedPriceString)円"
        }
    }
    static func mm_ss(_ sec: Int) -> String {
        let min = sec/60
        let sec = sec % 60
        return "\(String(format: "%02d", min)):\(String(format: "%02d", sec))"
    }
    static func time(sec: Int) -> String {
        var sec = sec
        var min = 0
        var hour = 0
        while sec > 60 {
            min += 1
            sec -= 60
        }
        while min > 60 {
            hour += 1
            min -= 60
        }
        var text = ""
        if hour != 0 { text += "\(hour)時間" }
        if min != 0 { text += "\(min)分" }
        return text + "\(sec)秒"
    }
    static func since(_ date: Date) -> String {
        if let inter = interval(since: date) {
            return inter
        }
        let today = Date()
        let todayEndComp = Calendar.current.dateComponents([.year, .month, .day], from: today)
        guard let todayEnd = todayEndComp.date else {
            return date.toFullString()
        }
        print("todayEnd", todayEnd.toFullString())
        for i in 1...6 {
            let modifiedDate = Calendar.current.date(byAdding: .day, value: i, to: todayEnd)!
            if date < modifiedDate {
                return "\(i)日前"
            }
        }
        let aMonthLater = Calendar.current.date(byAdding: .month, value: 1, to: todayEnd)!
        if date < aMonthLater {
            return "１週間以上前"
        } else {
            return "１ヶ月以上前"
        }
    }
    static func interval(since date: Date) -> String? {
        // マイナス＝過去、プラス＝未来
        let now = Date()
        let interval = Int(now.timeIntervalSince(date))
        print("interval", interval)
        switch interval {
        case Int.aHour..<Int.aDay: return "\(interval/Int.aHour)時間前"
        case Int.aMin..<Int.aHour: return "\(interval/Int.aMin)分前"
        case 0..<Int.aMin: return "\(interval)秒前"
        case -Int.aMin..<0: return "\(-interval)秒後"
        case -Int.aHour..<Int.aMin: return "\(-interval/Int.aMin)分後"
        case -Int.aDay..<Int.aHour: return "\(-interval/Int.aHour)時間後"
        default: break
        }
        let date_ymd = date.ymd()
        let today_ymd = now.ymd()
        if interval < 0 {
            if today_ymd.year==date_ymd.year, today_ymd.month==date_ymd.month {
                return "\(date_ymd.day-today_ymd.day)日後"
            }
        } else {
            if today_ymd.year==date_ymd.year, today_ymd.month==date_ymd.month {
                return "\(today_ymd.day-date_ymd.day)日前"
            }
        }
        return nil
    }
    static func date(_ timeStamp: Date) -> String {
        let today = Date().ymd()
        let posted = timeStamp.ymd()
        if posted.isSameDayAndTime(with: today){
            return "たった今"
        } else if let inter = interval(since: timeStamp) {
            return inter
        } else if today.year == posted.year {
            return timeStamp.toString(format: .MDE)
        } else {
            return timeStamp.toFullString()
        }
    }
}
struct Time {
    var hour = 0
    var min = 0
}
struct YMD {
    var year = 0
    var month = 0
    var day = 0
    var start: Time!
    var end: Time!
    
    func isSameDay(with date: YMD) -> Bool {
        return (date.year==year && date.month==month && date.day==day)
    }
    func isSameDayAndTime(with date: YMD) -> Bool {
        return (date.year==year && date.month==month && date.day==day && date.start?.hour==start?.hour && date.start?.min==start?.min)
    }
    // 日付までdateに
    func toDate(time: Time?) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.timeZone = .current
        components.year = year
        components.month = month
        components.day = day
        if let time = time {
            components.hour = time.hour
            components.minute = time.min
        }
        return calendar.date(from: components)!
    }
    func toDateAndTime() -> String {
        var date = toDate(time: nil).toString(format: .MDE)
        if date == Date().toString(format: .MDE) {
            date = "今日"
        }
        var dateText = "\(date)"
        if start != nil, end != nil {
            dateText += "\(start.hour.toTime):\(start.min.toTime)〜\(end.hour.toTime):\(end.min.toTime)"
        } else if let start = start {
            dateText += "\(start.hour.toTime):\(start.min.toTime)"
        }
        return dateText
    }
}
extension Int {
    
    var toTime: String {
        String(format: "%02d", self)
    }
}
extension Date {
    
    func ymd() -> YMD {
        let str = toString(format: .ymd).components(separatedBy: "/")
        return YMD(year: Int(str[0])!, month: Int(str[1])!, day: Int(str[2])!,
                    start: Time(hour: Int(str[3])!, min: Int(str[4])!))
    }
}
extension Int {
    
    static var aDay: Int { return .aHour*24 }
    static var aHour: Int { return .aMin*60 }
    static var aMin: Int { return 60 }
}
