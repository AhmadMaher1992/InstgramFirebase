//
//  HomeController.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 22/12/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController {
    
    
    var posts = [Post]()
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        fetchAllPosts()
        setupNavigationItems()
        setupObserver()
        
    }
    
    fileprivate func setupObserver(){
        let name = SharePhotoController.updateFieldNotificationName
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateField), name: name, object: nil)
    }
    @objc
    func handleUpdateField(){
        handleRefresh()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func handleRefresh(){
        posts.removeAll()
        fetchAllPosts()
    }
    
    func setupNavigationItems(){
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        let leftBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3"), style: .plain, target: self, action:#selector(handleCamera))
        navigationItem.leftBarButtonItem = leftBarItem
        
    }
    
    @objc
    func handleCamera(){
        let cameraController = CameraController()
        cameraController.modalPresentationStyle = .fullScreen
        present(cameraController, animated: true, completion: nil)
        
    }
    fileprivate func fetchAllPosts(){
        fetchFollowingUSersIDs()
        // fetchPosts()
    }
    
    fileprivate func fetchFollowingUSersIDs(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return}
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let usersIdDict = snapshot.value as? [String:Any] else { return }
            usersIdDict.forEach { (key,value) in
                Database.fetchUserWithUID(uid: key) { (user) in
                    self.fetchPostsWithUser(user: user)
                }
            }
            
        } withCancel: { (error) in
            print("Failed To Fetch Users you follow 😢",error )
        }
        
        
    }
    
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    
    fileprivate func fetchPostsWithUser(user: User){
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value)
            self.collectionView.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                //print("Key \(key), Value: \(value)")
                
                guard let dictionary = value as? [String: Any] else { return }
                var post = Post(user: user ,dictionary: dictionary)
                post.id = key
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value) { (snapshot) in
                    if let value = snapshot.value as? Int , value == 1 {
                        post.hasLiked = true
                    }else{
                        post.hasLiked = false
                    }
                    self.posts.append(post)
                    self.posts.sort { return $0.creationDate.compare($1.creationDate) == .orderedDescending  }
                    self.collectionView?.reloadData()
                    
                } withCancel: { (error) in
                    print("DEBUG: Disable To Fetch Likes Info For Post:  \(error)")
                }
                
                
            })
            
            
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    
    
}


//==========================================================
// MARK:- Collection View Delegate And Data Source
//==========================================================


extension HomeController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomePostCell
        let post = posts[indexPath.item]
        cell.post = post
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
}

//UICollectionViewDelegateFlowLayout

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = view.frame.size.width
        var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
        height += view.frame.width
        height += 50
        height += 60
        return CGSize(width: width, height: height)
    }
    
    
}


//==========================================================
// MARK:- HomeController Ex
//==========================================================
extension HomeController: HomePostCellDelegate {
    
    func onCommentTapped(post: Post ) {
        print("DEBUG:onCommentTapped: ",post.caption)
        let commentsVC = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsVC.post = post
        navigationController?.pushViewController(commentsVC, animated: true)
        
    }
    
    func onLikeTapped(for cell: HomePostCell) {
        guard let indexPath =   collectionView.indexPath(for: cell) else { return }
        
        var post = posts[indexPath.item]
        guard let postId = post.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [uid : post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (error, refernce) in
            if let error = error {
                print("DEBUG: Failed To Like Post\(error)")
                return
            }
            
            print("DEBUG: Successfully Like Post ")
            post.hasLiked = !post.hasLiked
            self.posts[indexPath.item] = post
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
    
}
