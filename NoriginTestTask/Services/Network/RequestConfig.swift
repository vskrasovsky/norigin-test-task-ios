//
//  RequestConfig.swift
//  NoriginTestTask
//
//  Created by user on 8/28/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Alamofire
import Foundation

struct BaseConfig {
    static let baseApiPath = "http://10.10.2.69:1337"
}

protocol RequestConfig {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
}

enum EPGRequestConfig: RequestConfig {
    case epg
    
    var path: String {
        switch self {
        case .epg:        return "/epg"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .epg:            return .get
        }
    }
    var parameters: Parameters {
        switch self {
        case .epg:            return [:]
        }
    }
}

