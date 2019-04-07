//
//  StudentLocationPOSTResponse.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 3/20/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import Foundation

struct StudentLocationPOSTResponse: Codable {
    let createdAt: String?
    let objectId: String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectId
    }
}
