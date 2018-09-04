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
            guard epg != nil else { return }
            updateViewModel()
            epgChanged?()
        }
    }
    var epgChanged: (() -> Void)?
    var haveData: Bool {
        return epg != nil
    }
    
    var epgStart: TimeInterval = .leastNormalMagnitude
    var epgEnd: TimeInterval = .greatestFiniteMagnitude
    var duration: TimeInterval {
        return epgEnd - epgStart
    }

    var days: [Date] = []
    var selectedDay: Date? {
        didSet {
            if selectedDay != oldValue {
                updateDayModels()
            }
        }
    }
    var dayCellModels: [DayCellModel] = [] {
        didSet {
            dayCellModelsChanged?()
        }
    }
    var dayCellModelsChanged: (() -> Void)?

    var hourCellModels: [HourCellModel] = []
    var channelViewModels: [ChannelViewModel] = []
    
    var activePrograms: [Program] = [] {
        didSet {
            if activePrograms != oldValue {
                activeProgramsChanged?()
            }
        }
    }
    var activeProgramsChanged: (() -> Void)?

    // this should be enough for smooth update of time line
    private let updateInterval: TimeInterval = 10
    var timer: Timer?
    var currentDate = Date(){
        didSet {
            currentDateChanged?()
        }
    }
    var currentDateChanged: (() -> Void)?

    init(epgService: EPGService) {
        self.epgService = epgService
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true, block: { [weak self] _ in
            self?.currentDate = Date()
            self?.updateActivePrograms()
        })
    }
    
    func loadData() {
        firstly { () -> Promise<EPG> in
            epg = nil
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
        updateDateLimits()
        updateDays()
        updateHours()
        updateChannels()
        updateActivePrograms()
    }
    
    private func updateDateLimits() {
        guard let epg = epg else { return }
        let allPrograms = epg.channels.flatMap { $0.programs }
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
        self.epgStart = start.timeInterval
        self.epgEnd = end.timeInterval
    }

    private func updateDays() {
        var day = epgStart.date.startOfDay()
        let endDay = epgEnd.date.startOfDay()
        var days = [Date]()
        while day <= endDay {
            days.append(day)
            day = day.later(byAdding: .day, value: 1)
        }
        self.days = days
        selectedDay = days.first
    }

    private func updateDayModels() {
        dayCellModels = days.map { DayCellModel(day: $0, selected: $0 == selectedDay) }
    }

    private func updateHours() {
        var hour = epgStart.date.nearestEarlierHalfAnHour()
        let endHour = epgEnd.date.nearestLaterHalfAnHour()
        var hourCellModels = [HourCellModel]()
        while hour < endHour {
            let title = DateFormatter.timeFormatter.string(from: hour.halfAnHourLater())
            let hourLater = hour.later(byAdding: .hour, value: 1)
            hourCellModels.append(HourCellModel(start: hour.timeInterval - epgStart, end: hourLater.timeInterval - epgStart, title: title))
            hour = hourLater
        }
        self.hourCellModels = hourCellModels
    }
    
    private func updateChannels() {
        guard let epg = epg else { return }
        channelViewModels = epg.channels.map({ channel -> ChannelViewModel in
            let programs = channel.programs.map({ p in
                return ProgramCellModel(
                    start: p.start.timeInterval - epgStart,
                    end: p.end.timeInterval - epgStart,
                    program: p
                )
            })
            return ChannelViewModel(logoURL: channel.logoURL, programs: programs)
        })
    }
    
    private func updateActivePrograms() {
        guard let epg = epg else { return }
        let allPrograms = epg.channels.flatMap { $0.programs }
        activePrograms = allPrograms.filter { ($0.start ... $0.end).contains(currentDate) }
    }
}
