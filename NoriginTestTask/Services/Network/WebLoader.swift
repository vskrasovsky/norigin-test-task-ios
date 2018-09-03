//
//  WebLoader.swift
//  NoriginTestTask
//
//  Created by user on 8/28/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Alamofire
import Foundation
import PromiseKit
import SwiftyJSON
import TRON

protocol WebLoader {
    func load<Model: Decodable>(config: RequestConfig, headers: [String: String]?) -> Promise<Model>
}

final class TRONWebLoader: WebLoader {
    private let tron: TRON
    
    init() {
        tron = TRON(baseURL: BaseConfig.baseApiPath)
        tron.parameterEncoding = JSONEncoding.default
    }
    
    func load<Model: Decodable>(config: RequestConfig, headers: [String: String]?) -> Promise<Model> {
        return Promise { seal in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let request: APIRequest<Model, JSON> = self.tron.codable(modelDecoder: decoder, errorDecoder: decoder).request(config.path)
            request.headers = headers ?? [:]
            request.parameters = config.parameters
            request.method = config.method
            if request.method == .get {
                request.parameterEncoding = URLEncoding.default
            }
            request.perform(withSuccess: { model in
                seal.fulfill(model)
            }, failure: { apiError in
                seal.reject(apiError)
            })
        }
    }
}
