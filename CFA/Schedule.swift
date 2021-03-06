//
//  ScheduleModel.swift
//  CFA
//
//  Created by Johnny Gu on 9/24/16.
//  Copyright © 2016 Johnny Gu. All rights reserved.
//

import Foundation

struct Schedule {
    let id: String
    let title: String
    let startTime: Date
    let endTime: Date
    let location: String
    var periodTimeString: String {
        return startTime.description + endTime.description
    }
}

extension Schedule: Comparable {
    init?(json: JSONDictionary) {
        guard
            let id              = json["id"] as? String,
            let title           = json["title"] as? String,
            let startTimeString = json["startTime"] as? String,
            let endTimeString   = json["endTime"] as? String,
            let startTime       = startTimeString.date,
            let endTime         = endTimeString.date,
            let location        = json["location"] as? String else { return nil }
        self.id         = id
        self.title      = title
        self.location   = location
        self.startTime  = startTime
        self.endTime    = endTime
    }
}

func ==(lhs: Schedule, rhs: Schedule) -> Bool{
    return
        lhs.title       == rhs.title &&
        lhs.location    == rhs.location &&
        lhs.startTime   == rhs.startTime &&
        lhs.endTime     == rhs.endTime
}
// check start time first, if equal, then endTime
func <(lhs: Schedule, rhs: Schedule) -> Bool {
    return lhs.startTime < rhs.endTime ||
        (lhs.startTime == rhs.endTime && lhs.endTime < rhs.endTime)
}
