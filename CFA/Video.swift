//
//  Video.swift
//  CFA
//
//  Created by Johnny Gu on 26/04/2017.
//  Copyright © 2017 Johnny Gu. All rights reserved.
//

import Foundation

struct Video {
    let id: String
    let title: String
    let uploadTime: Date?
    let lastTime: TimeInterval?
    let url: URL?
}

extension Video {
    init?(with json: JSONDictionary) {
        guard
            let id = json["id"] as? String,
            let title = json["title"] as? String
            else { return nil }
        self.id = id
        self.title = title
        self.uploadTime = (json["uploadTime"] as? TimeInterval).flatMap { Date(timeIntervalSince1970: $0) }
        self.lastTime = json["lastTime"] as? TimeInterval
        self.url = (json["url"] as? String).flatMap(URL.init)
    }
}
