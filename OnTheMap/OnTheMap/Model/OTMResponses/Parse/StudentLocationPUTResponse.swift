//
//  StudentLocationPUTResponse.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 3/27/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import Foundation

struct StudentLocationPUTResponse: Codable {
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case updatedAt
    }
}
