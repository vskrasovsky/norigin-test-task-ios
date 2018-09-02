//
//  EPGViewModel.swift
//  NoriginTestTask
//
//  Created by user on 8/31/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Foundation

struct EPGViewModel {
    let hours: [HourCellModel]
    let days: [Date]
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
                return ProgramCellModel(
                    startRatio: (p.start.timeIntervalSince1970 - start.timeIntervalSince1970) / duration,
                    endRatio: (p.end.timeIntervalSince1970 - start.timeIntervalSince1970) / duration, program: p
                )
            })
            return ChannelViewModel(logoURL: channel.logoURL, schedules: schedules)
        })
        
        var hour = start.nearestEarlierHalfAnHour()
        let endHour = end.nearestLaterHalfAnHour()
        var hourViewModels = [HourCellModel]()
        while hour < endHour {
            let startRatio = (hour.timeIntervalSince1970 - start.timeIntervalSince1970) / duration
            let title = DateFormatter.timeFormatter.string(from: hour.halfAnHourLater())
            let hourLater = hour.hourLater()
            let endRatio = (hourLater.timeIntervalSince1970 - start.timeIntervalSince1970) / duration
            hourViewModels.append(HourCellModel(startRatio: startRatio, endRatio: endRatio, title: title))
            hour = hourLater
        }
        self.hours = hourViewModels
        
        var day = start.startOfDay()
        let endDay = end.startOfDay()
        var days = [Date]()
        while day <= endDay {
            days.append(day)
            day = day.dayLater()
        }
        self.days = days

    }
}
