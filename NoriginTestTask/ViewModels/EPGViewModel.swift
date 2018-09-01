//
//  EPGViewModel.swift
//  NoriginTestTask
//
//  Created by user on 8/31/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Foundation

struct EPGViewModel {
    let hours: [HourCellViewModel]
    let days: [DayCellViewModel]
    let channels: [ChannelViewModel]
    let startInterval: TimeInterval
    let endInterval: TimeInterval
    let duration: TimeInterval

    
    init(epg: EPG) {
        let allPrograms = epg.channels.flatMap { $0.schedules }
        var start: Date = .distantFuture
        var end: Date = .distantPast
        allPrograms.forEach { program in
            if program.start < start {
                start = program.start
            }
            if program.end > end {
                end = program.end
            }
        }
        self.startInterval = start.timeIntervalSince1970
        self.endInterval = end.timeIntervalSince1970
        self.duration = endInterval - startInterval
        let duration = endInterval - startInterval
        channels = epg.channels.map({ channel -> ChannelViewModel in
            let schedules = channel.schedules.map({ p in
                return ProgramCellViewModel(
                    startRatio: (p.start.timeIntervalSince1970 - start.timeIntervalSince1970) / duration,
                    endRatio: (p.end.timeIntervalSince1970 - start.timeIntervalSince1970) / duration, program: p
                )
            })
            return ChannelViewModel(logoURL: channel.logoURL, schedules: schedules)
        })
        
        var hour = start.nearestEarlierHalfAnHour()
        let endHour = end.nearestLaterHalfAnHour()
        var hourCellViewModels = [HourCellViewModel]()
        while hour < endHour {
            let startRatio = (hour.timeIntervalSince1970 - start.timeIntervalSince1970) / duration
            let title = DateFormatter.timeFormatter.string(from: hour.halfAnHourLater())
            let hourLater = hour.hourLater()
            let endRatio = (hourLater.timeIntervalSince1970 - start.timeIntervalSince1970) / duration
            hourCellViewModels.append(HourCellViewModel(startRatio: startRatio, endRatio: endRatio, title: title))
            hour = hourLater
        }
        self.hours = hourCellViewModels
        
        var day = start.startOfDay()
        let endDay = end.startOfDay()
        var dayCellViewModels = [DayCellViewModel]()
        while day <= endDay {
            let dayOfWeekStr = DateFormatter.dayOfWeekFormatter.string(from: day)
            let dateStr = DateFormatter.dayMonthDateFormatter.string(from: day)
            dayCellViewModels.append(DayCellViewModel(date: day, dayOfWeekStr: dayOfWeekStr, dateStr: dateStr))
            day = day.dayLater()
        }
        self.days = dayCellViewModels

    }
}
