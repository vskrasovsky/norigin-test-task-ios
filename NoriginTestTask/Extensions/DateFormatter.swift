//
//  DateFormatter.swift
//  NoriginTestTask
//
//  Created by user on 8/31/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let timeFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let dayOfWeekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()

    static let dayMonthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter
    }()

}
