//
//  VideoDetailViewController.swift
//  CFA
//
//  Created by Johnny Gu on 27/04/2017.
//  Copyright © 2017 Johnny Gu. All rights reserved.
//

import UIKit

class VideoDetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var watchedBtn: UIButton!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var createUrlView: UIView!
    @IBOutlet weak var urlTextField: UITextField!
    
    var mode: ActionMode = .read
    var video: Resource?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configAction(mode)
        headerView.addSubview(createUrlView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        createUrlView.frame.size = headerView.frame.size
        createUrlView.frame.origin = CGPoint.zero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func downloadOrDeleteAction(_ sender: Any?) {
        guard let url = video?.url else { return }
        print("download from: \(url)")
    }
    
    @IBAction func markOrUnmarkAction(_ sender: Any?) {
        
    }
    
    @IBAction func saveAction(_ sender: Any?) {
        guard
            let title = titleTextField.text,
            let url = urlTextField.text else { return }
        if mode == .create {
            APIService.default.createResource(title: title, url: url, callback: { (result) in
                result.failureCallback({ (error) in
                    dump(error)
                }).successCallback({ (resource) in
                    self.video = resource
                    self.mode = .read
                })
            })
            return
        }
        guard let resource = video else { return }
        
    }
    
}
extension VideoDetailViewController {

    fileprivate func configAction(_ action: ActionMode) {
        titleTextField.isEnabled = mode != .read
        descriptionTextField.isEnabled = mode != .read
        watchedBtn.isHidden = mode != .read
        downloadBtn.isHidden = mode != .read
        saveBtn.isHidden = mode == .read
    }
}

