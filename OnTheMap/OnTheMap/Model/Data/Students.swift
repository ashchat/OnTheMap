//
//  Students.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 4/8/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import Foundation

class Students {
    
    static let shared = Students()
    
    var studentLocations: [StudentLocation] = []    // Can & Will be updated constantly - not static
    var userLocation: StudentLocation?              // Can potentially be updated if user decides to change the location they posted - not static
    static var uniqueKey = ""                       // This should not change
    static var userData: UserData?                  // This should not change
    
}
