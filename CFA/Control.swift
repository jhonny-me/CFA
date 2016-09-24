//
//  Control.swift
//  CFA
//
//  Created by Johnny Gu on 9/24/16.
//  Copyright © 2016 Johnny Gu. All rights reserved.
//

import Foundation

final public class Control {
    static var domainSetted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "com.wiredcraft.domainSetted")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "com.wiredcraft.domainSetted")
        }
    }
}
