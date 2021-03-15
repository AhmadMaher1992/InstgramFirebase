//
//  UserSearchController.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 27/12/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController {
    
    let cellId = "cellId"
    var filteredUsers = [User]()
    var users = [User]()
    
  
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    
    
   
    //=================================================
    // MARK:- Life Cycle
    //=================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupCollection()
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    //=================================================
    // MARK:- Helper
    //=================================================
    func configureUI(){
        
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    
    
    func setupCollection()  {
        
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        collectionView.keyboardDismissMode = .onDrag
    }
     func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
            self.view.endEditing(true)
        }
    
    fileprivate func fetchUsers() {
        print("Fetching users..")
        
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
          
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                if key == Auth.auth().currentUser?.uid  {
                    print("It Is Me 😅")
                    return
                }
                guard let userDictionary = value as? [String: Any] else { return }
                
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            })
          
            //sort user List Alphapitically
            self.users.sort(by: { (u1, u2) -> Bool in

                return u1.username.compare(u2.username) ==  ComparisonResult.orderedAscending

            })
            
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
            
        }) { (error) in
            self.showToast(message: " Failed to fetch users for search: \(error)")
            print("Failed to fetch users for search:", error)
        }
    }
    
   
    
   
}


//==========================================================
// MARK:-UserSearchController Collection View Extension
//==========================================================
extension UserSearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 66)
    }
}

//Data Source and Delegate
extension UserSearchController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userID = filteredUsers[indexPath.item].uid
        navigationController?.pushViewController(userProfileController, animated: true)
        //remove keyboard from screen
        searchBar.resignFirstResponder()
        print("user[\(indexPath.item)]")
    }
    
    
}

//===========================================
// MARK:-   UISearchBarDelegate
//===========================================
extension UserSearchController: UISearchBarDelegate {
    
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filteredUsers = searchText.isEmpty ? users : users.filter( { $0.username.localizedCaseInsensitiveContains(searchText) })
        
        self.collectionView?.reloadData()
        
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = true
        }
 

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            searchBar.showsCancelButton = false
            searchBar.text = ""
            self.filteredUsers = users
            self.collectionView.reloadData()
    
        }

}
