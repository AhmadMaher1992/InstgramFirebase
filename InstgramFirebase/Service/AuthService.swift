//
//  AuthService.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 24/12/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit
import Firebase

struct AuthCredentials {
    
    let email: String
    let password: String
    let username: String
    let profileImage: UIImage
    
}

struct AuthService {
    
    
    static let shared = AuthService()
    
    
    
    //Login USer
    
    func loginUser(email: String , password: String , completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion )
    }
    
    //Register USer
    func registerUser(credentials: AuthCredentials , completion: @escaping (Error?, DatabaseReference) -> Void){
        
        let email = credentials.email
        let password = credentials.password
        let profileImage = credentials.profileImage
        let username = credentials.username
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error )in
            if let error = error {
                print("Can't Create This USer: 😢" , error)
                return
            }
            guard let uid = authResult?.user.uid else { return }
            let image = profileImage
            guard let uploadData = image.jpegData(compressionQuality: 0.1) else { return }
            
            let metaDataConfig = StorageMetadata()
            metaDataConfig.contentType = "image/jpg"
            let storageReference =  Storage.storage().reference().child(Auth.auth().currentUser?.uid ?? "").child("profile_images")
            
            storageReference.putData(uploadData, metadata: metaDataConfig, completion: { (metadata, err) in
                
                if let err = err {
                    print("Failed to upload profile image: 😢", err)
                    return
                }
                    
                    storageReference.downloadURL{ (url, error) in
                        
                        if let error = error {
                            print("Unable to get Url ERROR: 😢" , error)
                            return
                        }
                        let UrlString = url?.absoluteString
                        guard let profileImageUrl = UrlString else { return }
                      //  print("profileImageUrl" , profileImageUrl)
                        let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl] as [String : Any]
                        let values = [uid : dictionaryValues]
                        Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: completion)
                        
                    }
              
                
                
                
            })
            
        }
    }
    
    
    
    
    
    
}


