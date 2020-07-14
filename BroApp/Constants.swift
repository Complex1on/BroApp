//
//  Constants.swift
//  BroApp
//
//  Created by Evan Yip on 7/3/20.
//  Copyright © 2020 Evan Yip. All rights reserved.
//

import Foundation
struct K {
    static let appName = "Bro for Bro"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerHomeSegue = "RegisterToHome"
    static let loginHomeSegue = "LoginToHome"
    static let homeChatSegue = "HomeToChat"
    static let homeFriends = "HomeToFriends"
    static let homeFriendRequest = "HomeToFriendRequest"
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
    
    struct FStoreUser {
        static let Username = "Username"
        static let email = "Email"
        static let uid = "uid"
        static let friends = "Friends"
        static let friendRequests = "FriendRequests"
    }
}
