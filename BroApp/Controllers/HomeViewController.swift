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
    var user = User(email: "", username: "", uid: "", friends: [], friendRequests: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        if let id = Auth.auth().currentUser?.uid{
            db.collection("Users").document(id).getDocument { (querySnapshot, error) in
                if let e = error{
                    print("Error getting user data: \(e)")
                } else {
                    if let doc = querySnapshot?.data(){
                        self.user.email = doc[K.FStoreUser.email] as! String
                        self.user.username = doc[K.FStoreUser.Username] as! String
                        self.user.uid = doc[K.FStoreUser.uid] as! String
                        self.user.friends = doc[K.FStoreUser.friends] as! [Dictionary<String,String>]
                        self.user.friendRequests = doc[K.FStoreUser.friendRequests] as! [Dictionary<String,String>]
                    }
                }
            }
        }
        
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
        performSegue(withIdentifier: K.homeFriendRequest, sender: self)
    }
    @IBAction func messagesButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: K.homeChatSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == K.homeFriends) {
            let destinationVC = segue.destination as! FriendsTableViewController
            destinationVC.user = user
        }
        
        if(segue.identifier == K.homeFriendRequest) {
            let destinationVC = segue.destination as! FriendRequestTableViewController
            destinationVC.user = user
        }
    }
}

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
//                            for test in data {
//                                print(test)
//                            }
//
//                        }
//                    }
//                }
//        }
