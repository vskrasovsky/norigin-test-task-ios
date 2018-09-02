//
//  Date.swift
//  NoriginTestTask
//
//  Created by user on 9/1/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Foundation

extension Date {
    
    // 15:37 -> 15:30, 00:25 -> 23:30
    func nearestEarlierHalfAnHour() -> Date {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        guard let minutes = dateComponents.minute else {
            assertionFailure("Date doesn't contain hour or minute component")
            return self
        }
        let deltaMinutes: Int
        if minutes <= 30 {
            deltaMinutes = minutes + 30
        } else {
            deltaMinutes = minutes - 30
        }
        
        var result = Calendar.current.date(byAdding: .minute, value: -deltaMinutes, to: self) ?? self
        
        //date without seconds and nonoseconds
        dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: result)
        result = Calendar.current.date(from: dateComponents) ?? self
        return result
    }

    // 15:37 -> 16:30, 00:25 -> 00:30
    func nearestLaterHalfAnHour() -> Date {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        guard let minutes = dateComponents.minute else {
            assertionFailure("Date doesn't contain hour or minute component")
            return self
        }
        let deltaMinutes: Int
        if minutes <= 30 {
            deltaMinutes = 30 - minutes
        } else {
            deltaMinutes = 90 - minutes
        }
        
        var result = Calendar.current.date(byAdding: .minute, value: deltaMinutes, to: self) ?? self
        
        //date without seconds and nonoseconds
        dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: result)
        result = Calendar.current.date(from: dateComponents) ?? self
        return result
    }

    func halfAnHourLater() -> Date {
        return Calendar.current.date(byAdding: .minute, value: 30, to: self) ?? self
    }

    
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    func dayLater() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self
    }
    func daysLater(count: Int = 1) -> Date {
        return Calendar.current.date(byAdding: .day, value: count, to: self) ?? self
    }

    func hourLater() -> Date {
        return Calendar.current.date(byAdding: .hour, value: 1, to: self) ?? self
    }
}
