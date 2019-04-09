//
//  Students.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 4/8/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import Foundation

struct Students {
    
    static let shared = Students()
    
    static var studentLocations: [StudentLocation] = []
    static var userLocation: StudentLocation?
    static var uniqueKey = ""
    static var userData: UserData?
    
}
