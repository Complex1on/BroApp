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
    
    //MARK: - Add Friend Funtionality
    // Description: Input email from a UIalert, finds db doc of that user, appends to that user's friend request array, outputs UIalert success or failure
    @IBAction func addFriendButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Friend", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Friend", style: .default) { (action) in
            
            let email = textField.text
            
            
            if(email != self.user?.email){
                self.db.collection("Users").whereField(K.FStoreUser.email, isEqualTo: email ?? "")
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            if let snapshotDocuments = querySnapshot?.documents {
                                if snapshotDocuments.count == 0 {
                                    self.alertUser(t: "Error!", m: "Failed to find friend with that email")
                                } else{
                                    let topDoc = snapshotDocuments[0].data()
                                    let foundUser = User(email: topDoc[K.FStoreUser.email] as! String, username: topDoc[K.FStoreUser.Username] as! String, uid: topDoc[K.FStoreUser.uid] as! String, friends: topDoc[K.FStoreUser.friends] as! [Dictionary<String,String>], friendRequests: topDoc[K.FStoreUser.friendRequests] as! [Dictionary<String,String>])
                                    
                                    self.validFriendRequest(currentUser: self.user!, foundUser: foundUser)
                                    
                                }
                                
                            }
                        }
                }
            }else {
                self.alertUser(t: "Error!", m: "This is your own email")
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type Friend's account email"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
    }
    
    //MARK: - Alert Functions
    func alertUser(t:String, m: String){
        let failedAlert = UIAlertController(title: t, message: m, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        failedAlert.addAction(action)
        self.present(failedAlert,animated: true,completion: nil)
    }
    
    func validFriendRequest(currentUser: User, foundUser: User) {
        let userAsFriend = Friend(uid: user?.uid ?? "", username: user?.username ?? "")
        
        var v : Bool = true
        for friend in foundUser.friendRequests{
            if(friend["uid"] == currentUser.uid){
                v = false
                alertUser(t: "Error!", m: "Already sent user a friend request")
            }
        }
        
        for friend in foundUser.friends{
            if(friend["uid"] == currentUser.uid){
                v = false
                alertUser(t: "Error!", m: "User is already your friend")
            }
        }
        
        for friend in currentUser.friendRequests{
            if(friend["uid"] == foundUser.uid){
                v = false
                alertUser(t: "Hey Look!", m: "That user already sent you a friend request! Check your Friend Requests")
            }
        }
        
        if(v){
            var newFRarray = foundUser.friendRequests
            newFRarray.append(userAsFriend.getDict())
            
            self.db.collection("Users").document(foundUser.uid).updateData([K.FStoreUser.friendRequests: newFRarray]) { (error) in
                if let e = error{
                    print("error appending user to other user's friend request array: \(e)")
                } else{
                    self.alertUser(t: "Success!", m: "Friend Request sent to user!")
                }
            }
        }
        
    }
}
