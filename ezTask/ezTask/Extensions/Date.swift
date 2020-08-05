//
//  Date.swift
//  ezTask
//
//  Created by Mike Ovyan on 27.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }

    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

    var endOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return gregorian.date(byAdding: .day, value: 7, to: sunday)! // TODO: check if this is nil
    }

    var second: Int { return Calendar.current.component(.second, from: self) }
    var minute: Int { return Calendar.current.component(.minute, from: self) }
    var hour: Int { return Calendar.current.component(.hour, from: self) }
    var day: Int { return Calendar.current.component(.day, from: self) }
    var month: Int { return Calendar.current.component(.month, from: self) }
    var year: Int { return Calendar.current.component(.year, from: self) }

    public func isToday() -> Bool {
        return self.startOfDay == Date().startOfDay
    }

    public func addDays(add days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: noon)!
    }

    public func isTomorrow() -> Bool {
        return self.startOfDay > Date().endOfDay && self.endOfDay < Date().dayAfter.dayAfter.startOfDay
    }

    public func dayNameOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: self)
    }
}
