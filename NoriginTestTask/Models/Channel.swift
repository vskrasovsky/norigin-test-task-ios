//
//  Channel.swift
//  NoriginTestTask
//
//  Created by user on 8/29/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Foundation

struct Channel: Decodable {
    var id: String
    var title: String
    var logoURL: String
    var programs: [Program]
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case images
        case schedules
    }
    
    enum ImagesKeys: CodingKey {
        case logo
    }
 
    // custom decoding because json structure differs from model's structure
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        let programs = try values.decode([Program].self, forKey: .schedules)
        
        let imagesInfo = try values.nestedContainer(keyedBy: ImagesKeys.self, forKey: .images)
        logoURL = try imagesInfo.decode(String.self, forKey: .logo)
        
        self.programs += programs.map { program -> Program in
            var program = program
            program.start = program.start.daysLater(count: i)
            program.end = program.end.daysLater(count: i)
            return program
        }
    }
}
