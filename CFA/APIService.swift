//
//  APIService.swift
//  CFA
//
//  Created by Johnny Gu on 9/24/16.
//  Copyright © 2016 Johnny Gu. All rights reserved.
//

import Foundation

let baseAPIURL = "http://35.189.185.244:3000/api"
let registerURL = baseAPIURL + "/managers"
let loginURL = baseAPIURL + "/managers/login"
let logoutURL = baseAPIURL + "/managers/logout"
let videoURL = baseAPIURL + "/videos"
let scheduleURL = baseAPIURL + "/schedules"
let newURL = baseAPIURL + "/news"
let namespaceAvailableURL = baseAPIURL + "/namespace/available"

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
    func baseRequest(method: HTTPMethod = .GET, url: String, param: JSONDictionary = [:], headers: [String: String] = [:], callback: @escaping (Result<JSONDictionary>) -> ()) {
        
        guard let url = URL(string: url) else { return callback(.failure(APIError.default)) }
//        guard let namespace = namespace else { return callback(.failure(APIError.namespaceNeed)) }
        
        var request = URLRequest.init(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 15)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields?["Accept"] = "application/json"
        request.allHTTPHeaderFields?["namespace"] = namespace
        headers.forEach { (key, value) in
            request.allHTTPHeaderFields?[key] = value
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
                guard let token = json["id"] as? String else { return callback(.failure(APIError.default)) }
                self.token = token
                callback(.success())
            }).failureCallback({ (error) in
                callback(.failure(error))
            })
        }
    }
    
    func logout(callback: @escaping (Result<Void>) -> ()) {
        requestWithToken(method: .POST, url: logoutURL) { (_) in
            
        }
    }
    
    func checkaAvailable(namespace: String, callback: @escaping (Result<Void>) -> ()) {
        baseRequest(method: .POST, url: namespaceAvailableURL, param: ["id": namespace]) { (result) in
            result.successCallback({ (json) in
                callback(.success())
            }).failureCallback({ (err) in
                callback(.failure(err))
            })
        }
    }
}

extension APIService {
    func getAllVideos(_ callback: @escaping (Result<[Video]>) -> ()) {
        baseRequest(url: videoURL) { (result) in
            result.successCallback({ (json) in
                guard
                    let videosJSON = json["data"] as? [JSONDictionary]
                    else { return callback(.failure(APIError.server))}
                let videos = videosJSON.flatMap(Video.init)
                callback(.success(videos))
            }).failureCallback({ (err) in
                callback(.failure(err))
            })
        }
    }
    
    func createVideo(title: String, url: String, callback: @escaping (Result<Video>) -> ()) {
        let param = [
            "title": title,
            "url": url
        ]
        requestWithToken(method: .POST, url: videoURL, param: param) { (result) in
            result.successCallback({ (json) in
                guard
                    let videoJson = json["data"] as? JSONDictionary,
                    let video = Video(with: videoJson) else { return callback(.failure(APIError.server)) }
                callback(.success(video))
            }).failureCallback({ (err) in
                callback(.failure(err))
            })
        }
    }
    
    func deleteVideo(id: String, callback: @escaping (Result<Void>) -> ()){
        requestWithToken(method: .DELETE, url: videoURL, param: ["id": id]) { (result) in
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



