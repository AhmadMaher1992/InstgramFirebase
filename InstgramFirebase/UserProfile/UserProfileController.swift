//
//  UserProfileController.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 16/11/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit
import Firebase
class UserProfileController: UICollectionViewController {
    
    
    //==========================================================
    // MARK:- Properties
    //==========================================================
    var user: User?
    var posts = [Post]()
    let cellId = "cellId"
    let  homePostCellId = "homePostCellId"
    var userID: String?
    var isGridView = true
    
    
    //==========================================================
    // MARK:- App Life Cycle
    //==========================================================
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        fetchUser()
        setupCollection()
        setupLogOutButton()
       // fetchOrderPosts()
    }
    
    //==========================================================
    // MARK:- Helpers
    //==========================================================
     
    func setupCollection(){
        collectionView?.backgroundColor = .white
        //navigationItem.title = Auth.auth().currentUser?.uid
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
    }
    
    
    
    fileprivate func fetchOrderPosts(){
        
       // guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let uid = user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        //create observer at this node
     
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with:{ (snapshot) in
       
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let user = self.user else { return}
            let post = Post(user: user , dictionary: dictionary)
            self.posts.insert(post, at: 0)
            
            self.collectionView?.reloadData()
      
        } ) {(error) in
            print("Failed to fetch ordered Posts",error)
        }
        
      
        
        
    }
   
    
    fileprivate func setupLogOutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
    }
    @objc func handleLogout(){
        let alertController = UIAlertController(title: nil , message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do{
                try  Auth.auth().signOut()
                let loginVC = LoginController()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }catch let err{
                print("CAn't SignOut", err)
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func fetchUser() {
        let uid = userID ?? ( Auth.auth().currentUser?.uid ??
            "")
     //   guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.collectionView?.reloadData()
            self.fetchOrderPosts()
        }
    }
    
    
    
    
}



//==========================================================
// MARK:- Collection View Delegate And Data Source
//==========================================================


extension UserProfileController: UICollectionViewDelegateFlowLayout {
    
    // Asks the delegate for the size of the header view in the specified section.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}

extension UserProfileController {
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
  
  
    
    //Cell For Collection
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isGridView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
             cell.post = posts[indexPath.item]
             return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.item]
            return cell
        }
      
    }
    //Header For Collection
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        //  header.backgroundColor = .green
        header.user = self.user
        header.delegate = self
        return header
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isGridView {
            
            let width = (view.frame.width - 3 ) / 3
            return CGSize(width: width, height: width)
            
        }else {
            
            let width:CGFloat = view.frame.size.width
            var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
            height += view.frame.width
            height += 50
            height += 60
            return CGSize(width: width, height: height)
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}


//==========================================================
// MARK:- Collection View Delegate And Data Source
//==========================================================

extension UserProfileController: UserProfileHeaderDelegate {
   
    
    func onChangeToGridView() {
        collectionView.reloadData()
        isGridView = true
        
        
    }
    
    func onChangeToListView() {
        collectionView.reloadData()
        isGridView = false
    }
    
    
}
