//
//  UIColor+CFA.swift
//  CFA
//
//  Created by Johnny Gu on 9/19/16.
//  Copyright © 2016 Johnny Gu. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: Int,g: Int, b: Int) {
        let red = Float(r)/255.0
        let green = Float(g)/255.0
        let blue = Float(b)/255.0
        self.init(colorLiteralRed: red, green: green, blue: blue, alpha: 1)
    }
}
