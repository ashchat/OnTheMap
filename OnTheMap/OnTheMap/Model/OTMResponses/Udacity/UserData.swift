//
//  UserData.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 4/4/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import Foundation

struct UserData: Codable {
    
    let firstname: String
    let lastname: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case firstname = "first_name"
        case lastname = "last_name"
        case key
    }
    
}
