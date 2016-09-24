//
//  APIService.swift
//  CFA
//
//  Created by Johnny Gu on 9/24/16.
//  Copyright © 2016 Johnny Gu. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: AnyObject]

struct Resource<T> {
    let url: URL
    let parse: (Data) -> T?
}

extension Resource {
    init(url: URL, parseClosure: @escaping (Any) -> T?) {
        self.url = url
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseClosure)
        }
    }
    
    
}

final class APIService {
    func load<T>(resource: Resource<T>, completion: @escaping (T?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { (data, _, _) in
            let result = data.flatMap(resource.parse)
            completion(result)
        }.resume()
    }
}
