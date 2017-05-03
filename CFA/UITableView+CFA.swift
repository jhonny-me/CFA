//
//  UITableView+CFA.swift
//  CFA
//
//  Created by Johnny Gu on 02/05/2017.
//  Copyright © 2017 Johnny Gu. All rights reserved.
//

import UIKit

var noneDataViewKey = 0
var tapActionKey = 1

extension UIScrollView {
    static let defaultAnimationDuration: TimeInterval = 0.3
    private(set) var noneDataView: UIView? {
        get {
            return objc_getAssociatedObject(self, &noneDataViewKey) as? UIView
        }
        set {
            if let noneDataView = noneDataView { noneDataView.removeFromSuperview() }
            objc_setAssociatedObject(self, &noneDataViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private(set) var tapActionOnNoneDataView: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &tapActionKey) as? () -> Void
        }
        set {
            objc_setAssociatedObject(self, &tapActionKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    func setNoneDataView(_ view: UIView, tapAction: @escaping () -> Void) {
        noneDataView = view
        tapActionOnNoneDataView = tapAction
    }
    
    func showNoneDataView(animated: Bool = true) {
        assert(noneDataView != nil, "You should set noneDataView before using it!")
        guard let noneDataView = noneDataView else { return }
        if let _ = noneDataView.superview {
            noneDataView.removeFromSuperview()
        }
        let finalClosure: (Bool) -> Void = { _ in
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.triggerNoneDataViewAction))
            noneDataView.addGestureRecognizer(tap)
        }
        if animated {
            UIView.transition(with: self, duration: UIScrollView.defaultAnimationDuration, options: [.curveEaseIn, .transitionCurlUp], animations: { 
                self.addSubview(noneDataView)
            }, completion: finalClosure)
        }else {
            self.addSubview(noneDataView)
            finalClosure(false)
        }
    }
    
    func triggerNoneDataViewAction() {
        noneDataView?.removeFromSuperview()
        tapActionOnNoneDataView?()
    }
}
