//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 3/20/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import Foundation

struct LoginRequest: Encodable {
    
    var username: String
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case udacity
    }
    
    enum udacityCodingKeys: String, CodingKey {
        case username
        case password
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var udacity = container.nestedContainer(keyedBy: udacityCodingKeys.self, forKey: .udacity)
        try udacity.encode(username, forKey: .username)
        try udacity.encode(password, forKey: .password)
    }
    
}


