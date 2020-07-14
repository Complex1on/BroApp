//
//  User.swift
//  BroApp
//
//  Created by Evan Yip on 7/4/20.
//  Copyright © 2020 Evan Yip. All rights reserved.
//

import Foundation
import Firebase

struct User {
    var email: String
    var username: String
    var uid: String
    var friends: [Dictionary<String,String>]
    var friendRequests: [Dictionary<String,String>]
    
}
