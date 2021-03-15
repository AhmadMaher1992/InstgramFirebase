//
//  FireDatabase.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 23/12/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit
import Firebase

extension Database {
    
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
            
        }) { (err) in
            print("Failed to fetch user for posts😢:", err)
        }
    }
}


//filterArray = usersArray.filter({$0.name.lowercased().range(of: tst )  != nil}).sorted(by: {$0.name.compare($1.name) == .orderedAscending})
