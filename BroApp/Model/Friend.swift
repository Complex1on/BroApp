//
//  Friend.swift
//  BroApp
//
//  Created by Evan Yip on 7/13/20.
//  Copyright © 2020 Evan Yip. All rights reserved.
//

import Foundation
import Firebase

struct Friend {
    var uid: String
    var username: String
    
    func getDict() -> [String:String] {
        let dict = ["uid": uid, "username" : username]
        return dict
    }
}
