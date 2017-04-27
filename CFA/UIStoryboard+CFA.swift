//
//  UIStoryboard+CFA.swift
//  CFA
//
//  Created by Johnny Gu on 26/04/2017.
//  Copyright © 2017 Johnny Gu. All rights reserved.
//

import UIKit

extension UIStoryboard {
    enum Name: String {
        case Main
    }
    
    convenience init(_ name: Name) {
        self.init(name: name.rawValue, bundle: nil)
    }
    
    func initiate<T: UIViewController>(_ type: T.Type) -> T {
        return instantiateViewController(withIdentifier: String(describing: type)) as! T
    }
}
