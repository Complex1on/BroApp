//
//  FriendsTableViewController.swift
//  BroApp
//
//  Created by Evan Yip on 7/5/20.
//  Copyright © 2020 Evan Yip. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    let friendsArray = ["Complexion","Test username", "Rob"]
    var user: User? {
        didSet{
            print("Set User")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
//    override func viewWillAppear(_ animated: Bool) {
//        <#code#>
//    }
    
    //MARK: - tableview data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
        cell.textLabel?.text = friendsArray[indexPath.row]
        return cell
    }
   
}
