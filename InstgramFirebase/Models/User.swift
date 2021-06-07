//
//  User.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 23/12/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//


import Foundation
//MARK:- User Model
struct User {
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init( uid: String , dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = uid
    }
}

