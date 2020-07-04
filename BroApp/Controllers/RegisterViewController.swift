//
//  RegisterViewController.swift
//  BroApp
//
//  Created by Evan Yip on 7/3/20.
//  Copyright © 2020 Evan Yip. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                    self.ErrorLabel.text = e.localizedDescription
                } else {
                    // Navigate to HomeViewController
                    self.performSegue(withIdentifier: K.registerHomeSegue, sender: self)
                }
            }
        }
        
        
    }
    
}
