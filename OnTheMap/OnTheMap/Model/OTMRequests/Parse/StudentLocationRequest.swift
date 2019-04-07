//
//  StudentLocationRequest.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 3/20/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import Foundation

struct StudentLocationRequest: Codable {
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let location: String?
    let mediaURL: String?
    let uniqueKey: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case latitude
        case longitude
        case location = "mapString"
        case mediaURL
        case uniqueKey
    }
}
