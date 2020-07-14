//
//  FriendRequestTableViewController.swift
//  BroApp
//
//  Created by Evan Yip on 7/13/20.
//  Copyright © 2020 Evan Yip. All rights reserved.
//

import UIKit
import SwipeCellKit
class FriendRequestTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    
    
    var user: User? {
        didSet{
            print("set Friend Request User")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.rowHeight = 80.0
        

    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.friendRequests.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = user?.friendRequests[indexPath.row]["username"]
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: - SwipeView
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("delete")

            
            //tableView.reloadData()
        }
        
        let addAction = SwipeAction(style: .default, title: "Add") { action, indexPath in
            // handle action by updating model with deletion
            print("add")

            
            //tableView.reloadData()
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

}
