//
//  StudentLocationsResponse.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 3/20/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import Foundation

struct StudentLocationsResponse: Codable {
    
    let StudentLocations: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case StudentLocations = "results"
    }
    
}
