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
    static let baseApiPath = "http://localhost:1337"
}

protocol RequestConfig {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
}

enum CommonInfoRequestConfig: RequestConfig {
    
    case allAutoBrands
    case allWorkshopServices
    
    var path: String {
        switch self {
        case .allAutoBrands:        return "/info/GetAutobrands?autotype=1"
        case .allWorkshopServices:  return "/info/gethierarchical"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .allAutoBrands:            return .get
        case .allWorkshopServices:      return .get
        }
    }
    var parameters: Parameters {
        switch self {
        case .allAutoBrands:            return [:]
        case .allWorkshopServices:      return [:]
        }
    }
}

