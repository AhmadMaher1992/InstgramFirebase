//
//  Comment.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 10/03/2021.
//  Copyright © 2021 Ahmad Eisa. All rights reserved.
//


import Foundation

struct Comment {
    
    let user: User
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
