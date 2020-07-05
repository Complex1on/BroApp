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
    let db = Firestore.firestore()
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                    self.ErrorLabel.text = e.localizedDescription
                } else {
                    // Navigate to HomeViewController
                    if let user = Auth.auth().currentUser?.uid {
                        // take out email later
                        // since you can get email from Auth.auth()
                        self.db.collection("Users").document(user).setData(["Username": self.usernameTextField.text ?? "No Username", "uid": user])
                            //.addDocument(data: )
                    }
                    
                    self.performSegue(withIdentifier: K.registerHomeSegue, sender: self)
                }
            }
        }
        
        
    }
    
}
