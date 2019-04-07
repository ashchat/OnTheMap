//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 3/18/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import Foundation

class ParseClient {
    
    static let parseAppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    static let appIdHeader = "X-Parse-Application-Id"
    static let apiKeyHeader = "X-Parse-REST-API-Key"
    
    enum Endpoints {
        
        static let base = "https://parse.udacity.com/parse/classes/StudentLocation"
        
        case studentLocations
        case studentLocation(String)
        case putStudentLocation(String)
        
        var stringValue: String {
            switch self {
            case .studentLocations: return Endpoints.base + "?limit=100&order=-updatedAt"
            case .studentLocation(let uniqueKey): return Endpoints.base + "?where=%7B%22uniqueKey%22%3A%22" + uniqueKey + "%22%7D"
            case .putStudentLocation(let objectId): return Endpoints.base + "/" + objectId
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult class func taskForGETStudentLocation(uniqueKey: String?, completion: @escaping (StudentLocationsResponse?, Error?) -> Void) -> URLSessionTask {
        let url = (uniqueKey != nil) ? Endpoints.studentLocation(uniqueKey!).url : Endpoints.studentLocations.url
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(parseAppId, forHTTPHeaderField: appIdHeader)
        request.addValue(apiKey, forHTTPHeaderField: apiKeyHeader)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(StudentLocationsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func taskForPOSTStudentLocation<StudentLocation: Encodable>(body: StudentLocation, completion: @escaping (StudentLocationPOSTResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.studentLocations.url)
        request.httpMethod = "POST"
        request.addValue(parseAppId, forHTTPHeaderField: appIdHeader)
        request.addValue(apiKey, forHTTPHeaderField: apiKeyHeader)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(StudentLocationPOSTResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForPUTStudentLocation<StudentLocation: Encodable>(objectId: String, body: StudentLocation, completion: @escaping (StudentLocationPUTResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.putStudentLocation(objectId).url)
        request.httpMethod = "PUT"
        request.addValue(parseAppId, forHTTPHeaderField: appIdHeader)
        request.addValue(apiKey, forHTTPHeaderField: apiKeyHeader)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(StudentLocationPUTResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
}

