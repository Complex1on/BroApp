//
//  FriendsTableViewController.swift
//  BroApp
//
//  Created by Evan Yip on 7/5/20.
//  Copyright © 2020 Evan Yip. All rights reserved.
//

import UIKit
import Firebase

class FriendsTableViewController: UITableViewController {
    
    let friendsArray = ["Complexion","Test username", "Rob"]
    let db = Firestore.firestore()
    var user: User? {
        didSet{
            print("Set User")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    //MARK: - tableview data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userFriends = user?.friends.count ?? 0
        return userFriends
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
        cell.textLabel?.text = user?.friends[indexPath.row]["username"]
        return cell
    }
   
    @IBAction func addFriendButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Friend", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Friend", style: .default) { (action) in

            let email = textField.text
            let userAsFriend = Friend(uid: self.user?.uid ?? "", username: self.user?.username ?? "")
            
            self.db.collection("Users").whereField(K.FStoreUser.email, isEqualTo: email ?? "")
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        if let snapshotDocuments = querySnapshot?.documents {
                            if snapshotDocuments.count == 0 {
                                let failedAlert = UIAlertController(title: "Error!", message: "Failed to find friend with that email", preferredStyle: .alert)
                                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                failedAlert.addAction(action)
                                self.present(failedAlert,animated: true,completion: nil)
                            } else{
                                let topDoc = snapshotDocuments[0].data()
                                let foundUID = topDoc[K.FStoreUser.uid] as? String ?? ""
                                //let foundUsername = topDoc[K.FStoreUser.Username] as? String ?? ""
                                var foundFriendRequest = topDoc[K.FStoreUser.friendRequests] as! [Dictionary<String,String>]
                                foundFriendRequest.append(userAsFriend.getDict())

                                self.db.collection("Users").document(foundUID).updateData([K.FStoreUser.friendRequests: foundFriendRequest]) { (error) in
                                    if let e = error{
                                        print("error appending user to other user's friend request array: \(e)")
                                    } else{
                                        let successAlert = UIAlertController(title: "Success!", message: "Friend Request sent to user!", preferredStyle: .alert)
                                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        successAlert.addAction(action)
                                        self.present(successAlert,animated: true,completion: nil)
                                    }
                                }
                                
                            }
                            
                        }
                    }
            }
            
//            newCat.name = textField.text!
//            newCat.colour = UIColor.randomFlat().hexValue()
//            self.saveCategories(category: newCat)
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type Friend's account email"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert,animated: true,completion: nil)
    }
}
