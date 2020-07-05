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
        
        //TESTING QUERYING FOR A DIFFERENT USER
        db.collection("Users").whereField("Username", isEqualTo: "Test username")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            let id = doc.documentID
                            print(id)
                            print(data)
                            
                        }
                    }
                }
        }
    }
    @IBAction func friendsButtonPushed(_ sender: UIButton) {
    }
    @IBAction func friendRequestButtonPushed(_ sender: UIButton) {
    }
    @IBAction func messagesButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: K.homeChatSegue, sender: self)
    }
}
