//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 3/27/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import Foundation

class UdacityClient {
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        case userData(String)
        case udacitySignup
        
        var stringValue: String {
            switch self {
            case .session: return Endpoints.base + "/session"
            case .userData(let userId): return Endpoints.base + "/users/" + userId
            case .udacitySignup: return "https://www.udacity.com/account/auth#!/signup"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    class func taskForPOSTSession<LoginRequest: Encodable>(body: LoginRequest, completion: @escaping (LoginResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                performUIUpdatesOnMain {
                    completion(nil, error)
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let responseObject = try decoder.decode(LoginResponse.self, from: newData)
                performUIUpdatesOnMain {
                    completion(responseObject, nil)
                }
            } catch {
                performUIUpdatesOnMain {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForDELETESession(completion: @escaping (LogoutResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                performUIUpdatesOnMain {
                    completion(nil, error)
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let responseObject = try decoder.decode(LogoutResponse.self, from: newData)
                performUIUpdatesOnMain {
                    completion(responseObject, nil)
                }
            } catch {
                performUIUpdatesOnMain {
                    completion(nil, error)
                }
            }
            
        }
        task.resume()
    }
    
    class func taskForGETUserData(userId: String, completion: @escaping (UserData?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.userData(userId).url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                performUIUpdatesOnMain {
                    completion(nil, error)
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let responseObject = try decoder.decode(UserData.self, from: newData)
                performUIUpdatesOnMain {
                    completion(responseObject, nil)
                }
            } catch {
                performUIUpdatesOnMain {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
}
