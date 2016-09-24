//
//  Date+CFA.swift
//  CFA
//
//  Created by Johnny Gu on 9/24/16.
//  Copyright © 2016 Johnny Gu. All rights reserved.
//

import Foundation

extension Date {
    var string: String {
        let formatter = DateFormatter()
        return formatter.string(from: self)
    }
}
