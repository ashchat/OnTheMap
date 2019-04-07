//
//  LogoutResponse.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 3/28/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import Foundation

struct LogoutResponse: Codable {
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case session
    }
}
