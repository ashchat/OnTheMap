//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 3/20/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case account
        case session
    }
}

struct Account: Codable {
    let registered: Bool
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case registered
        case key
    }
}

struct Session: Codable {
    let id: String
    let expiration: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case expiration
    }
}

//
//"account":{
//    "registered":true,
//    "key":"3903878747"
//},
//"session":{
//    "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
//    "expiration":"2015-05-10T16:48:30.760460Z"
//}
