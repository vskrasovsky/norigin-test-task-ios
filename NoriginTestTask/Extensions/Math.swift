//
//  Math.swift
//  NoriginTestTask
//
//  Created by user on 9/2/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Foundation

func clip<T>(value: T, toRange range: Range<T>) -> T {
    precondition(range.lowerBound < range.upperBound)
    if value < range.lowerBound {
        return range.lowerBound
    } else if value > range.upperBound {
        return range.upperBound
    } else {
        return value
    }
}
