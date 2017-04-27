//
//  SetupViewController.swift
//  CFA
//
//  Created by Johnny Gu on 9/24/16.
//  Copyright © 2016 Johnny Gu. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    @IBOutlet weak var domianNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func skipButton_Pressed() {
        dismiss(animated: true, completion: nil)
    }

    func checkAvailable() {
        let namespace = domianNameTextField.text!
        APIService.default.checkaAvailable(namespace: namespace) { (result) in
            result.successCallback { result in
                if result {
                    let register = UIStoryboard(.Main).initiate(LoginViewController.self)
                    register.isRegister = true
                    register.namespace = namespace
                    self.present(register, animated: true, completion: nil)
                }else {
                    APIService.default.namespace = namespace
                    self.dismiss(animated: true, completion: nil)
                }
            }.failureCallback({ (err) in
                print(err)
            })
        }
    }
}

extension SetupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkAvailable()
        return true
    }
}
