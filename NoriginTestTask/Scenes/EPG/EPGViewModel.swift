//
//  EPGViewModel.swift
//  NoriginTestTask
//
//  Created by user on 9/3/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Foundation
import PromiseKit

class EPGViewModel {
    
    private let epgService: EPGService
    
    var isLoading: Bool = false {
        didSet {
            isLoadingChanged?()
        }
    }
    var isLoadingChanged: (() -> Void)?

    private var epg: EPG? {
        didSet {
            updateViewModel()
            epgChanged?()
        }
    }
    var epgChanged: (() -> Void)?
    
    var start: Date = Date()
    var end: Date = Date()
    var duration: TimeInterval = 1

    var days: [Date] = []

    var hourCellModels: [HourCellModel] = []
    
    var channelCellModels: [ChannelViewModel] = []

    
    init(epgService: EPGService) {
        self.epgService = epgService
    }
    
    func loadData() {
        firstly { () -> Promise<EPG> in
            isLoading = true
            return epgService.epg()
        }
        .done { [weak self] epg in
            self?.epg = epg
        }.ensure { [weak self] in
            self?.isLoading = false
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    private func updateViewModel() {
        guard let epg = epg else { return }
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
        self.start = start
        self.end = end
        self.duration = end.timeIntervalSince1970 - start.timeIntervalSince1970

        updateDays()
        updateHours()
        updateChannels()
    }
    
    private func updateDays() {
        var day = start.startOfDay()
        let endDay = end.startOfDay()
        var days = [Date]()
        while day <= endDay {
            days.append(day)
            day = day.dayLater()
        }
        self.days = days
    }

    private func updateHours() {
        var hour = start.nearestEarlierHalfAnHour()
        let endHour = end.nearestLaterHalfAnHour()
        var hourCellModels = [HourCellModel]()
        while hour < endHour {
            let startRatio = (hour.timeIntervalSince1970 - start.timeIntervalSince1970) / duration
            let title = DateFormatter.timeFormatter.string(from: hour.halfAnHourLater())
            let hourLater = hour.hourLater()
            let endRatio = (hourLater.timeIntervalSince1970 - start.timeIntervalSince1970) / duration
            hourCellModels.append(HourCellModel(startRatio: startRatio, endRatio: endRatio, title: title))
            hour = hourLater
        }
        self.hourCellModels = hourCellModels
    }
    
    private func updateChannels() {
        guard let epg = epg else { return }
        channelCellModels = epg.channels.map({ channel -> ChannelViewModel in
            let schedules = channel.schedules.map({ p in
                return ProgramCellModel(
                    startRatio: (p.start.timeIntervalSince1970 - start.timeIntervalSince1970) / duration,
                    endRatio: (p.end.timeIntervalSince1970 - start.timeIntervalSince1970) / duration, program: p
                )
            })
            return ChannelViewModel(logoURL: channel.logoURL, schedules: schedules)
        })
    }
}
