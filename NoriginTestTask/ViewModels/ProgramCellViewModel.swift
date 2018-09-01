//
//  ProgramCellViewModel.swift
//  NoriginTestTask
//
//  Created by user on 8/31/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Foundation

struct ProgramCellViewModel {
    var startRatio: Double
    var endRatio: Double
    
    var title: String
    var timeIntervalFormatted: String
    
    init(startRatio: Double, endRatio: Double, program: Program) {
        self.startRatio = startRatio
        self.endRatio = endRatio
        self.title = program.title
        self.timeIntervalFormatted = "\(DateFormatter.timeFormatter.string(from: program.start)) - \(DateFormatter.timeFormatter.string(from: program.end))"
    }
}
