//
//  HomeViewController.swift
//  BroApp
//
//  Created by Evan Yip on 7/4/20.
//  Copyright © 2020 Evan Yip. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        //TESTING QUERYING FOR A DIFFERENT USER
//        db.collection("Users").whereField("Username", isEqualTo: "Complexion")
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    if let snapshotDocuments = querySnapshot?.documents {
//                        for doc in snapshotDocuments{
//                            let data = doc.data()
//                            let id = doc.documentID
//                            print(id)
//                            print(data["Username"] as! String)
////                            for test in data {
////                                print(test)
////                            }
//
//                        }
//                    }
//                }
//        }
    }
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
          
    }
    @IBAction func friendsButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: K.homeFriends, sender: self)
    }
    @IBAction func friendRequestButtonPushed(_ sender: UIButton) {
    }
    @IBAction func messagesButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: K.homeChatSegue, sender: self)
    }
}
