//
//  FriendRequestTableViewController.swift
//  BroApp
//
//  Created by Evan Yip on 7/13/20.
//  Copyright © 2020 Evan Yip. All rights reserved.
//

import UIKit
import SwipeCellKit
import Firebase

class FriendRequestTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    var user: User? {
        didSet{
            print("set Friend Request User")
        }
    }
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.rowHeight = 80.0
        
    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("data count")
        return user?.friendRequests.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("data load")
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = user?.friendRequests[indexPath.row]["username"]
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: - Help Button
    @IBAction func helpButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    //MARK: - SwipeView Methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            // 1. delete the request from the user's friend requests
            
            self.deleteFriendRequest(indexPath.row)
            
            tableView.reloadData()
        }
        
        let addAction = SwipeAction(style: .default, title: "Add") { action, indexPath in
            // handle action by updating model with add
            print("add")
            
            // 1. Add friend to both user's lists
            self.addFriend(currentUser: self.user!, requestUID: self.user?.friendRequests[indexPath.row]["uid"] ?? "")
            // 2. Create new peer to peer message between the two
            self.createNewConv(currUID: self.user?.uid ?? "", friendUID: self.user?.friendRequests[indexPath.row]["uid"] ?? "")
            // 3. delete request
            self.deleteFriendRequest(indexPath.row)
            tableView.reloadData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-iconpng")
        addAction.backgroundColor = UIColor(red: 0.40, green: 0.80, blue: 0.40, alpha: 1.00)

        return [deleteAction,addAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.transitionStyle = .border
        return options
    }
    
    //MARK: - Firebase DB funcs
    func deleteFriendRequest(_ index : Int) {
        if var FRarray = user?.friendRequests{
            FRarray.remove(at: index)
            user?.friendRequests = FRarray
            
            db.collection("Users").document(user?.uid ?? "").updateData([K.FStoreUser.friendRequests : FRarray]){ err in
                if let e = err {
                    print("Failed to update data \(e)")
                }else{
                    print("doc successfully updated: ")
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    func addFriend(currentUser: User, requestUID: String){
        
        var friendUser = User(email: "", username: "", uid: "", friends: [], friendRequests: [])
        var user = currentUser
        
        db.collection("Users").document(requestUID).getDocument { (document, error) in
            if let doc = document{
                if let data = doc.data() {
                    friendUser.friendRequests = data[K.FStoreUser.friendRequests] as! [Dictionary<String,String>]
                    friendUser.friends = data[K.FStoreUser.friends] as! [Dictionary<String,String>]
                    friendUser.uid = data[K.FStoreUser.uid] as! String
                    friendUser.email = data[K.FStoreUser.email] as! String
                    friendUser.username = data[K.FStoreUser.Username] as! String
                    
                    let friendUserAsFriend = Friend(uid: friendUser.uid, username: friendUser.username)
                    friendUser.friends.append(friendUserAsFriend.getDict())
                    
                    let userAsFriend = Friend(uid: user.uid, username: user.username)
                    user.friends.append(userAsFriend.getDict())
                }
                
            } else {
                print("doc does not exist")
            }
        }
        
        db.collection("Users").document(user.uid).updateData([K.FStoreUser.friends: user.friends])
        db.collection("Users").document(friendUser.uid).updateData([K.FStoreUser.friends: friendUser.friends])
        
    }
    
    func createNewConv(currUID: String, friendUID: String){
        var convoUID: String
        if (currUID < friendUID){
            convoUID = currUID + friendUID
        }else {
            convoUID = friendUID + currUID
        }
        db.collection("Messages").document(convoUID).setData(["convo" : []])
        
    }
    
    func updateData(){
        db.collection("Users").document(user?.uid ?? "").getDocument { (doc, error) in
            if let e = error{
                print(e)
            }else{
                if let data = doc?.data(){
                    self.user?.friends = data[K.FStoreUser.friends] as! [Dictionary<String,String>]
                    self.user?.friendRequests = data[K.FStoreUser.friendRequests] as! [Dictionary<String,String>]
                }
            }
        }
    }

}
