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
        if let video = video {
            titleTextField.text = video.name
            descriptionTextField.text = video.description
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
            self.showProgress()
            APIService.default.createResource(title: title, url: url, callback: { (result) in
                self.hideAllHUD()
                result.failureCallback({ (error) in
                    self.showToast(error.localizedDescription)
                }).successCallback({ (resource) in
                    self.video = resource
                    self.mode = .read
                    self.configAction(.read)
                })
            })
            return
        }
        guard let resource = video else { return }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
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

