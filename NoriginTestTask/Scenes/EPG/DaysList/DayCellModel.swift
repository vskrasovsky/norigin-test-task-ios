//
//  DayCellModel.swift
//  NoriginTestTask
//
//  Created by user on 9/1/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Foundation

struct DayCellModel {
    var day: Date
    var selected: Bool
    
    var dayOfWeekStr: String {
        return DateFormatter.dayOfWeekFormatter.string(from: day)
    }
    var dateStr: String {
        return DateFormatter.dayMonthDateFormatter.string(from: day)
    }
}
