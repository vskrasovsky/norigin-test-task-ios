//
//  WebService.swift
//  NoriginTestTask
//
//  Created by user on 8/28/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Foundation
import PromiseKit
import TRON

class WebService {
    private let loader: WebLoader
    private let headers: [String: String] = ["Accept": "application/json"]
    
    init(loader: WebLoader) {
        self.loader = loader
    }
    
    func load<Model: Decodable>(config: RequestConfig) -> Promise<Model> {
        return loader.load(config: config, headers: headers)
    }
}
