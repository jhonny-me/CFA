//
//  LoginViewController.swift
//  CFA
//
//  Created by Johnny Gu on 26/04/2017.
//  Copyright © 2017 Johnny Gu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var namespaceLabel: UILabel!
    @IBOutlet weak var namespaceTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var isRegister = false
    var namespace:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        namespaceLabel.isHidden = !isRegister
        namespaceTextField.isHidden = !isRegister
        namespaceTextField.text = namespace
        loginBtn.setTitle(isRegister ? "register": "login", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginOrRegisterAction(with sender: Any) {
        let namespace = namespaceTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        if isRegister {
            APIService.default.register(namespace: namespace, email: email, password: password, callback: { (result) in
                result.successCallback {
                    APIService.default.login(email: email, password: password, callback: { (loginResult) in
                        loginResult.successCallback {
                            APIService.default.namespace = namespace
                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            })
        }else {
            APIService.default.login(email: email, password: password, callback: { (result) in
                result.successCallback {
                    self.dismissAction(with: self)
                }
            })
        }
    }

    @IBAction func dismissAction(with sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
