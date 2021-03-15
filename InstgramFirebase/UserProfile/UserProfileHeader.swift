//
//  UserProfileHeader.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 17/11/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    var user: User?{
        didSet{
            guard let imageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: imageUrl)
            self.usernameLabel.text = user?.username ?? "Ahmad"
            setupEditFollowButton()
            
        }
    }
    
    private func  setupEditFollowButton(){
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        guard let userID = user?.uid else { return }
        
        if currentUserID == userID {
            
        }else{
            //check if follow
            Database.database().reference().child("following").child(currentUserID).child(userID).observeSingleEvent(of: .value) { (snapshot) in
                
                if let isFollowing = snapshot.value as? Int , isFollowing == 1 {
                    self.editFollowProfileButton.setTitle("UnFollow", for: .normal)
                }else {
                    
                    self.setupFollowStyle()
                    
                }
                
            } withCancel: { (error) in
                print("Failed To Check Following Status or Not😢\(error)")
                
            }
            
        }
        
    }
    
  
    lazy var editFollowProfileButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.layer.cornerRadius = 3
        btn.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(handleEditFollowBtn), for: .touchUpInside)
        return btn
    }()
    @objc
    func handleEditFollowBtn(){
        
        guard let currentLoggedinUserID = Auth.auth().currentUser?.uid else { return }
        
        guard let userID = user?.uid else { return }
        if editFollowProfileButton.titleLabel?.text == "unfollow" {
           Database.database().reference().child("following").child(currentLoggedinUserID).child(userID).removeValue { (error, reference) in
                if let error = error {
                    print("Failed To Unfollow 😢 \(error)")
                    return
                }
                print("Success Remove Follow")
            self.setupFollowStyle()
         
            }
            
        }else{
            let values = [userID : 1]
            let ref = Database.database().reference().child("following").child(currentLoggedinUserID)
            ref.updateChildValues(values) { (error, reference) in
                if let error = error {
                    print("Failed To Follow User 😢 \(error)")
                    return
                }
                print("Sussceefuly Follow User\(self.user?.username)")
                self.setupUNfollowStyle()
                
            }
        }
        
    }
    func setupUNfollowStyle(){
        self.editFollowProfileButton.setTitle("unfollow", for: .normal)
        self.editFollowProfileButton.backgroundColor = .white
        self.editFollowProfileButton.setTitleColor(.black, for: .normal)
    }
    func setupFollowStyle(){
        self.editFollowProfileButton.setTitle("Follow", for: .normal)
        self.editFollowProfileButton.backgroundColor = .rgb(red: 17, green: 154, blue: 237)
        self.editFollowProfileButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        self.editFollowProfileButton.setTitleColor(.white, for: .normal)
    }
    
    let profileImageView: CustomImageView = {
        let im = CustomImageView()
        return im
    }()
    
    let usernameLabel:UILabel = {
        let label = UILabel()
        label.text = "username"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let gridbutton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return btn
    }()
    let listButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    let bookmarkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    
    
    let postsLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Posts", attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0 //multi Line
        label.textAlignment = .center
        return label
    }()
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Followes", attributes: [.foregroundColor: UIColor.lightGray,.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [.foregroundColor: UIColor.black,.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Following", attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
    }
    
    func configureUI(){
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.clipsToBounds = true
        setupBottomToolbar()
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridbutton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        setupUserStatsView()
        addSubview(editFollowProfileButton)
        editFollowProfileButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 34)
    }
    
    fileprivate func setupUserStatsView(){
        let stackView = UIStackView(arrangedSubviews: [postsLabel,followersLabel,followingLabel])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
        
    }
    
    fileprivate func setupBottomToolbar(){
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridbutton,listButton,bookmarkButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        addSubview(topDividerView)
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        addSubview(bottomDividerView)
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

