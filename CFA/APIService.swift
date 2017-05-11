//
//  APIService.swift
//  CFA
//
//  Created by Johnny Gu on 9/24/16.
//  Copyright © 2016 Johnny Gu. All rights reserved.
//

import Foundation

let isStaging = false

let baseAPIURL = isStaging ? "http://192.168.0.103:3000/api" : "http://104.199.245.204:3000/api"
let registerURL = baseAPIURL + "/managers"
let loginURL = baseAPIURL + "/managers/login"
let logoutURL = baseAPIURL + "/managers/logout"

let resourceURL = baseAPIURL + "/resources"

let scheduleURL = baseAPIURL + "/schedules"
let newURL = baseAPIURL + "/news"
let namespaceAvailableURL = baseAPIURL + "/Namespaces/available"

enum APIError: Error {
    case timeout
    case namespaceNeed
    case notAuthrized
    case parse
    case server
    case `default`
}

enum Result<T> {
    case failure(Error)
    case success(T)
    
    @discardableResult func successCallback(_ callback: @escaping (T) -> ()) -> Result<T> {
        DispatchQueue.main.async {
            if case .success(let value) = self {
                callback(value)
            }
        }
        return self
    }
    
    @discardableResult func failureCallback(_ callback: @escaping (Error) -> ()) -> Result<T> {
        DispatchQueue.main.async {
            if case .failure(let error) = self {
                callback(error)
            }
        }
        return self
    }
}

typealias JSONDictionary = [String: Any]

final class APIService: NSObject {
    static let `default` = APIService()
    enum HTTPMethod: String {
        case GET, POST, DELETE, PUT
    }
    func baseRequest(method: HTTPMethod = .GET, url: String, param: JSONDictionary? = nil, headers: [String: String] = [:], callback: @escaping (Result<JSONDictionary>) -> ()) {
        
        guard let url = URL(string: url) else { return callback(.failure(APIError.default)) }
        
        var request = URLRequest.init(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 15)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields?["Accept"] = "application/json"
        request.allHTTPHeaderFields?["Content-Type"] = "application/json"
        request.allHTTPHeaderFields?["namespace"] = namespace
        headers.forEach { (key, value) in
            request.allHTTPHeaderFields?[key] = value
        }
        request.httpShouldHandleCookies = false
        if let param = param {
            request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error { return callback(.failure(error)) }
            guard
                let data = data,
                let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSONDictionary else { return callback(.failure(APIError.parse))}
            print("url: \(url), data: \(json)")
            callback(.success(json))
        }.resume()
    }
    
    func requestWithToken(method: HTTPMethod, url: String, param: JSONDictionary = [:], headers: [String: String] = [:], callback: @escaping (Result<JSONDictionary>) -> ()) {
        guard let token = token else { return callback(.failure(APIError.notAuthrized)) }
        var headers = headers
        headers["Authorization"] = token
        baseRequest(method: method, url: url, param: param, headers: headers, callback: callback)
    }
}

extension APIService {
    func register(namespace: String, email: String, password: String, callback: @escaping (Result<Void>) -> ()) {
        let param = [
            "namespace": namespace,
            "email": email,
            "password": password
        ]
        baseRequest(method: .POST, url: registerURL, param: param) { (result) in
            if case .failure(let err) = result {
                return callback(.failure(err))
            }
            callback(.success())
        }
    }
    
    func login(email: String, password: String, callback: @escaping (Result<Void>) -> ()) {
        let param = [
            "email": email,
            "password": password
        ]
        baseRequest(method: .POST, url: loginURL, param: param) { (result) in
            result.successCallback({ (json) in
                guard let token = (json["data"] as? JSONDictionary)?["id"] as? String else { return callback(.failure(APIError.default)) }
                self.token = token
                callback(.success())
            }).failureCallback({ (error) in
                callback(.failure(error))
            })
        }
    }
    
    func logout(callback: @escaping (Result<Void>) -> ()) {
        requestWithToken(method: .POST, url: logoutURL) { (result) in
            result.successCallback({ (_) in
                callback(.success())
            }).failureCallback({ (err) in
                callback(.failure(err))
            })
        }
    }
    
    func checkaAvailable(namespace: String, callback: @escaping (Result<Bool>) -> ()) {
        baseRequest(method: .POST, url: namespaceAvailableURL, param: ["title": namespace]) { (result) in
            result.successCallback({ (json) in
                guard let result = (json["data"] as? JSONDictionary)?["result"] as? Bool else {
                    return callback(.failure(APIError.server))
                }
                callback(.success(result))
            }).failureCallback({ (err) in
                callback(.failure(err))
            })
        }
    }
}

extension APIService {
    func getAllResources(_ callback: @escaping (Result<[Resource]>) -> ()) {
        baseRequest(url: resourceURL) { (result) in
            result.successCallback({ (json) in
                guard
                    let videosJSON = json["data"] as? [JSONDictionary]
                    else { return callback(.failure(APIError.server))}
                let videos = videosJSON.flatMap(Resource.init)
                callback(.success(videos))
            }).failureCallback({ (err) in
                callback(.failure(err))
            })
        }
    }
    
    func createResource(title: String, url: String, callback: @escaping (Result<Resource>) -> ()) {
        let type = URL(string: url)?.pathExtension
        var param = [
            "name": title,
            "url": url
        ]
        param["type"] = type
        requestWithToken(method: .POST, url: resourceURL, param: param) { (result) in
            result.successCallback({ (json) in
                guard
                    let resource = (json["data"] as? JSONDictionary).flatMap(Resource.init) else { return callback(.failure(APIError.server)) }
                callback(.success(resource))
            }).failureCallback({ (err) in
                callback(.failure(err))
            })
        }
    }
    
    func deleteResource(id: String, callback: @escaping (Result<Void>) -> ()){
        requestWithToken(method: .DELETE, url: resourceURL, param: ["id": id]) { (result) in
            result.successCallback({ (_) in
                callback(.success())
            }).failureCallback({ (err) in
                callback(.failure(err))
            })
        }
    }
}

extension APIService {
    var namespace: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "com.johnny.cfa.apiservice.namespace")
        }
        get {
            return UserDefaults.standard.string(forKey: "com.johnny.cfa.apiservice.namespace")
        }
    }
    
    var token: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "com.johnny.cfa.apiservice.token")
        }
        get {
            return UserDefaults.standard.string(forKey: "com.johnny.cfa.apiservice.token")
        }
    }
}



