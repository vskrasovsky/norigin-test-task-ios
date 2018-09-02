//
//  EPGService.swift
//  NoriginTestTask
//
//  Created by user on 9/3/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Foundation
import PromiseKit

protocol EPGService {
    func epg() -> Promise<EPG>
}
