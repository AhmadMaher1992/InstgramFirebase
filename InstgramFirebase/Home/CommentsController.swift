//
//  CommentsController.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 07/03/2021.
//  Copyright © 2021 Ahmad Eisa. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController {
    
    var post: Post?
    let cellId = "cellId"
    var commentsArray = [Comment]()
    let commentTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Comment"
        tf.textAlignment = .left
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 50/2
        tf.layer.masksToBounds = true
        tf.borderStyle = .none
        tf.leftViewMode = .always
        return tf
    }()
    //==========================================================
    // MARK:- Life Cycle
    //==========================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        //this is the fix to empty space down collection view
        collectionView.contentInset = UIEdgeInsets(top: 10 , left: 0, bottom: 10, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 10 , left: 0, bottom: 10, right: 0)
        fetchComments()
        
    }
    fileprivate func  fetchComments(){
        guard let postId =  self.post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe( .childAdded) { (snapShot) in
            //   print("DEBUG: SnapShot: \(snapShot.value)")
            guard let dictionary = snapShot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                
                let comment = Comment(user: user, dictionary: dictionary)
                self.commentsArray.append(comment)
                self.collectionView?.reloadData()
            })
            
        } withCancel: { (error) in
            
            print("DEBUG: Failed To Fetch Comments: \(error)")
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    lazy var containerView: UIView = {
        //Set up the container
        let containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 0.9784782529, green: 0.9650371671, blue: 0.9372026324, alpha: 1)
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 70)
        
        containerView.addSubview(commentTF)
        
        commentTF.setLeftPaddingPoints(10)
        commentTF.setRightPaddingPoints(10)
        // textField.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let button = UIButton(type: .system)
        containerView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        commentTF.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: button.leftAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)
        
        
        button.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 70, height: 0)
        
        
        
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        containerView.addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        return containerView
    }()
    @objc
    func handleSubmit(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print("DEBUG: Post ID: \(post?.id)")
        let postID = post?.id ?? ""
        let values = ["text" : commentTF.text ?? "" ,
                      "creationDate" : Date().timeIntervalSince1970 ,
                      "uid": uid] as [String : Any]
        Database.database().reference().child("comments").child(postID).childByAutoId().updateChildValues(values) { (error, ref) in
            if let error = error {
                print("DEBUG: Failed To Insert Comments Error: \(error)")
                return
            }
            print("DEBUG: Successful Inserted Comment")
            
        }
    }
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
}


extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


extension CommentsController{
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentsArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = commentsArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


extension CommentsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = commentsArray[indexPath.item]
        dummyCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
}







@IBDesignable
extension UITextField {
    
    @IBInspectable var paddingLeftCustom: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
}


