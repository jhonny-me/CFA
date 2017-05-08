//
//  SwiftHUD.swift
//  CFA
//
//  Created by Johnny Gu on 04/05/2017.
//  Copyright © 2017 Johnny Gu. All rights reserved.
//

import UIKit
import SnapKit

// SwiftHUD draws hud views in a context
// In a context, you can specify many options sets
// SwiftHUD provides a default context which you can use

// Edit:
// Since every HUD view will display as some UIView's subview
// It is more resonable to keep all configure data just with every HUD view instead of a context

// SwiftHUD using chain style to config a HUD before you show it up
// Newly configured style will override context setting which HUD is currently drawing in
//

// Usage:
// SwiftHUD(.toast("I'm a toast"))
//   .duration(4).animated(false).position(.bottom)
//   .withBackholder(ture)
//   .removeFromSuperViewWhenHide(true)
//   .addTo(self.view)
//   .show()

// Or:
// SwiftHUD(.error("This is a error"), options: [.animated, .bottom, .withBackholder, .removeWhenHide]).show()

// Most common:
// SwiftHUD.showProgress()

// Context configured:
// let hud = SwiftHUD()
// hud.show(.success("success"))

// Manuplate hud:
// let hud = SwiftHUD()
// hud.show(.success("success"))
// hud.hide(hudView)
// Or: 
// hud.hideLast()

// Even, you can bind a hud to a view or viewcontroller, then in your viewcontroller:
// self.show(.success("success"))
// self.hide()


extension SwiftHUD {
    enum HUDType {
        case progress(String?)
        case success(String?)
        case error(String?)
        case info(String?)
        case toast(String)
        //        case notification(UIView)
    }
    
    enum QueueStyle {
        case pipe  // only shows the earliest
        case stack // only shows the newest
        case concurrent // all shows on screen
    }
    
    enum AnimationStyle {
        case none
        case EaseInOut
        case EaseIn
        case EaseOut
    }
    
    enum Position {
        case top
        case bottom
        case center
    }
    
    struct Options: OptionSet {
        let rawValue: Int
        static let allowUserInteraction = Options(rawValue: 1<<0)
        
        static let `default`: Options = [.allowUserInteraction]
    }
}

class SwiftHUD: UIView {
    fileprivate(set) var onScreenDuration: TimeInterval = 3
    fileprivate(set) var queueStyle: QueueStyle = .concurrent
//    private(set) var animated: Bool = true
    fileprivate(set) var animationStyle: AnimationStyle = .EaseInOut
    fileprivate(set) var position: Position = .center
    fileprivate(set) var options: Options = .default
    
    fileprivate(set) var destinationView: UIView? = UIApplication.shared.keyWindow
    fileprivate(set) var backgroundView: UIView
    fileprivate(set) var bezelView: UIView
    fileprivate(set) var indicatorView: UIView?
    fileprivate(set) lazy var messageLabel: UILabel = {
        return UILabel()
    }()
    
    fileprivate var timer: Timer?
    
    override init(frame: CGRect) {
        self.backgroundView = UIView()
        self.bezelView = UIView()
        super.init(frame: frame)
        self.commonInit()
//        self.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        bezelView.backgroundColor = UIColor.lightGray
        bezelView.layer.cornerRadius = 4.0
        bezelView.layer.masksToBounds = true
        bezelView.layer.shadowPath = UIBezierPath(rect: bezelView.bounds).cgPath
        bezelView.layer.shadowColor = UIColor.black.cgColor
        bezelView.layer.shadowOffset = CGSize(width: 0, height: 1)
        bezelView.layer.shadowOpacity = 0.2
    }
}

extension SwiftHUD {
    var isVisible: Bool {
        return alpha > 0.01 && bezelView.alpha > 0.01
    }
    
    convenience init(view: UIView) {
        self.init(frame: view.bounds)
    }
    
    convenience init(type: HUDType, options: Options = .default) {
        self.init(frame: CGRect.zero)
        switch type {
        case .progress(let string):
            self.indicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
            self.messageLabel.text = string
        case .error(let error):
            self.indicatorView = UIImageView(image: UIImage(named: ""))
            self.messageLabel.text = error
        case .info(let info):
            self.messageLabel.text = info
        case .success(let success):
            self.messageLabel.text = success
        case .toast(let toast):
            self.messageLabel.text = toast
        }
    }
    
    static func huds(on view: UIView) -> [SwiftHUD] {
        return view.subviews.filter { $0.isKind(of: SwiftHUD.self) } as! [SwiftHUD]
    }
    
    func addTo(_ view: UIView) -> SwiftHUD {
        self.destinationView = view
        frame = view.bounds
        timer?.invalidate()
        return self
    }
    
    func duration(_ duration: TimeInterval) -> SwiftHUD {
        self.onScreenDuration = duration
        return self
    }
    
    func queueStyle(_ style: QueueStyle) -> SwiftHUD {
        self.queueStyle = style
        return self
    }
    
    func position(_ position: Position) -> SwiftHUD {
        self.position = position
        return self
    }
    
    func addOption(_ option: Options) -> SwiftHUD {
        self.options = self.options.union(option)
        return self
    }
    
    func show() {
        /// autolayouts
        removeFromSuperview()
        destinationView?.addSubview(self)
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self)
        }
        backgroundView.addSubview(bezelView)
        
        bezelView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(backgroundView)
            switch position {
            case .center:
                maker.centerY.equalTo(backgroundView)
            case .top:
                maker.top.equalTo(backgroundView).offset(20)
            case .bottom:
                maker.bottom.equalTo(backgroundView).offset(-20)
            }
        }
        
        if let indicatorView = indicatorView {
            bezelView.addSubview(indicatorView)
            
            indicatorView.snp.makeConstraints({ (maker) in
                maker.centerX.equalToSuperview()
                maker.top.equalToSuperview().offset(10)
                maker.left.greaterThanOrEqualToSuperview().offset(10)
            })
        }
        
        bezelView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            if let indicatorView = indicatorView {
                maker.top.equalTo(indicatorView.snp.bottom).offset(10)
            }else {
                maker.top.equalToSuperview().offset(10)
            }
            maker.bottom.equalToSuperview().offset(-10)
            maker.left.equalToSuperview().offset(10)
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
        // animation
        let bezelSnap = bezelView.snapshotView(afterScreenUpdates: true)
        let container = UIView(frame: bezelView.frame)
        
        destinationView?.addSubview(container)
        self.alpha = 0
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.1) {
            UIView.transition(with: container, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                container.addSubview(bezelSnap!)
            }) { (_) in
                container.removeFromSuperview()
                self.alpha = 1
                (self.indicatorView as? UIActivityIndicatorView)?.startAnimating()
            }
        }
        
        
        // options
        isUserInteractionEnabled = !options.contains(.allowUserInteraction)
        
        // timer
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: onScreenDuration, target: self, selector: #selector(hide), userInfo: nil, repeats: false)
    }
    
    func hide() {
        timer?.invalidate()
        self.alpha = 0
    }
}

