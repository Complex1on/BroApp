//
//  FriendRequestTableViewController.swift
//  BroApp
//
//  Created by Evan Yip on 7/13/20.
//  Copyright © 2020 Evan Yip. All rights reserved.
//

import UIKit

class FriendRequestTableViewController: UITableViewController {
    
    var user: User? {
        didSet{
            print("set Friend Request User")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self

    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.friendRequests.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath)
        cell.textLabel?.text = user?.friendRequests[indexPath.row]["username"]
        return cell
    }

}
