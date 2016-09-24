//
//  NewModel.swift
//  CFA
//
//  Created by Johnny Gu on 9/24/16.
//  Copyright © 2016 Johnny Gu. All rights reserved.
//

import Foundation

struct New {
    let title: String
    let time: Date
    let imageURLs: [URL]
    var imageCountString: String {
        return "\(imageURLs.count) photos"
    }
}
