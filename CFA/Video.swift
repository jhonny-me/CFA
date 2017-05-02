//
//  Video.swift
//  CFA
//
//  Created by Johnny Gu on 26/04/2017.
//  Copyright © 2017 Johnny Gu. All rights reserved.
//

import Foundation

struct Resource {
    let fileType: FileType
    let name: String
    let id: String
    let url: URL?
    let coverUrl: URL?
    let size: Int?
    let description: String?
    let scheduleId: String?
}

extension Resource {
    enum FileType: String {
        case png, jpg
        case mp4
        case ppt
        case markdown
    }
}

extension Resource {
    init?(_ json: JSONDictionary) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String,
            let type = (json["type"] as? String).flatMap(FileType.init)
            else { return nil }
        self.id = id
        self.name = name
        self.fileType = type
        self.url = (json["url"] as? String).flatMap(URL.init)
        self.coverUrl = (json["coverUrl"] as? String).flatMap(URL.init)
        self.size = json["size"] as? Int
        self.description = json["description"] as? String
        self.scheduleId = json["scheduleId"] as? String
    }
}
