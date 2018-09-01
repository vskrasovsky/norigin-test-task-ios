//
//  Program.swift
//  NoriginTestTask
//
//  Created by user on 8/29/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

struct Program: Decodable {
    var id: String
    var title: String
    var start: Date
    var end: Date    
}
