//
//  ProgramCellModel.swift
//  NoriginTestTask
//
//  Created by user on 8/31/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Foundation

struct ProgramCellModel {
    var start: TimeInterval
    var end: TimeInterval
    var program: Program
    
    var title: String
    var timeIntervalFormatted: String
    
    init(start: TimeInterval, end: TimeInterval, program: Program) {
        self.start = start
        self.end = end
        self.program = program
        self.title = program.title
        self.timeIntervalFormatted = "\(DateFormatter.timeFormatter.string(from: program.start)) - \(DateFormatter.timeFormatter.string(from: program.end))"
    }
}
