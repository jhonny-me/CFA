//
//  SwiftHUD+CFA.swift
//  CFA
//
//  Created by Johnny Gu on 08/05/2017.
//  Copyright © 2017 Johnny Gu. All rights reserved.
//

import UIKit

extension UIViewController {
    func showProgress() {
        SwiftHUD(type: .progress("loading")).duration(TimeInterval.infinity).addTo(view).show()
    }
    
    func showToast(_ message: String = "Something went wrong") {
        SwiftHUD(type: .toast(message)).position(.bottom).addTo(view).show()
    }
    
    func hideAllHUD() {
        view.hideAllHUD()
    }
}
