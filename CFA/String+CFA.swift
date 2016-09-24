//
//  String+CFA.swift
//  CFA
//
//  Created by Johnny Gu on 9/24/16.
//  Copyright © 2016 Johnny Gu. All rights reserved.
//

import Foundation

extension String {
    var date: Date? {
        let formatter =  DateFormatter()
        return formatter.date(from: self)
    }
}
