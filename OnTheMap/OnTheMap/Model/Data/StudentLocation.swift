//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 3/18/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let location: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case latitude
        case longitude
        case location = "mapString"
        case mediaURL
        case objectId
        case uniqueKey
        case createdAt
        case updatedAt
    }
    
    static func == (lhs: StudentLocation, rhs: StudentLocation) -> Bool {
        return lhs.objectId == rhs.objectId
    }
    
}
