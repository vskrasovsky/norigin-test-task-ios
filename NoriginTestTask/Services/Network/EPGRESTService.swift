//
//  EPGWebService.swift
//  NoriginTestTask
//
//  Created by user on 8/29/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Foundation
import PromiseKit

class EPGRESTService: WebService {
    func epg() -> Promise<EPG> {
        return load(config: EPGRequestConfig.epg)
    }    
}
