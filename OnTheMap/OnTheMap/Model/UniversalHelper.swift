//
//  UniversalHelper.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 4/2/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

// Universal variables to be used for consistency and prevent unnecessary memory usage
var studentLocations = [StudentLocation]()
var uniqueKey = ""
var userLocation: StudentLocation?
var userData: UserData?

// Universal Alert Popup function to be reused anywhere in the app
let okayAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
let cancelAlertAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

func showAlert(controller: UIViewController, title: String?, error: String?, actions: [UIAlertAction]) {
    let alert = UIAlertController(title: title ?? "", message: error ?? "", preferredStyle: .alert)
    for action in actions {
        alert.addAction(action)
    }
    controller.present(alert, animated: true, completion: nil)
}

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}


// Universal activity indicator to be used anywhere in the app
var activityIndicator = UIActivityIndicatorView()
var bg = UIView()

func callActivityIndicator(view: UIView) {
    bg.frame = view.frame
    bg.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    bg.addSubview(activityIndicator)
    activityIndicator.center = view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.style = .whiteLarge
    view.addSubview(bg)
    activityIndicator.startAnimating()
}

func stopActivityIndicator() {
    bg.removeFromSuperview()
    activityIndicator.stopAnimating()
}


// Pulled from: https://stackoverflow.com/questions/30743408/check-for-internet-connection-with-swift
// Confirms the user has a network connection
func checkForInternet() -> Bool {
    var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
        return false
    }
    
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    let ret = (isReachable && !needsConnection)
    
    return ret
}


// User friendly Error messages for the alert popups
enum ErrorMessages {
    
    case connectionError
    case loginError
    case getStudentLocations
    case confirmLogout
    case successfulLogout
    case unsuccessfulLogout
    case getUserData
    case noURL
    case userLocationExists
    case geocodeError
    case successfulLocation
    case unsuccessfulLocation
    case needMoreInfo
    case cancelAddLocation
    
    var stringValue: String {
        switch self {
        case .connectionError: return "Please check your network connection and try again."
        case .loginError: return "Invalid username/password. Please try again."
        case .getStudentLocations: return "Could not get student locations. Please try refreshing."
        case .confirmLogout: return "Are you sure you want to logout?"
        case .successfulLogout: return "You have successfully logged out."
        case .unsuccessfulLogout: return "Could not log out at this time. Please try again."
        case .getUserData: return "Could not retrieve User Data. Please check network connection and try again."
        case .noURL: return "This user has not provided a URL."
        case .userLocationExists: return "Looks like you have posted a location already, would you like to overwrite this?"
        case .geocodeError: return "Error while trying to pin your location. Please try again!"
        case .successfulLocation: return "Successfully uploaded your location. This will appear as a blue pin on the map."
        case .unsuccessfulLocation: return "Could not upload your location at this time. Please check your network connection and try again."
        case .needMoreInfo: return "Please enter both a location and a URL."
        case .cancelAddLocation: return "The data you provided will be dismissed."
        }
    }
    
}


// NotificationCenter: Used to allow for a better link between pages' data
extension Notification.Name {
    
    static let updateLocations = Notification.Name(rawValue: "updateLocations")
    
}
