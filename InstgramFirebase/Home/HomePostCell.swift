//
//  HomePostCell.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 22/12/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit


//Custom Delegation Pattern
protocol HomePostCellDelegate {
    func onCommentTapped(post: Post)
    func onLikeTapped(for cell: HomePostCell)
}

class HomePostCell: UICollectionViewCell {
    
    
    
    //==========================================================
    // MARK:-Properties
    //==========================================================
    var delegate: HomePostCellDelegate?
    
    var post: Post? {
        didSet{
            likeButton.setImage(post?.hasLiked == true ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected") .withRenderingMode(.alwaysOriginal)  , for: .normal)
            guard let imageUrl = post?.imageUrl else { return}
            photoImageView.loadImage(urlString: imageUrl)
            usernameLabel.text = post?.user.username
            guard let profileImgUrl = post?.user.profileImageUrl else { return }
            self.userProfileImageView.loadImage(urlString: profileImgUrl)
            setupAttributedCaption()
        }
    }
    
    fileprivate func  setupAttributedCaption(){
        guard let post = post else { return }
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "  \(post.caption)", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [.font: UIFont.systemFont(ofSize: 4)]))
        let timeAgoTodisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgoTodisplay, attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.gray]))
        
        captionLabel.attributedText = attributedText
    }
    
    let userProfileImageView: CustomImageView = {
        let img = CustomImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .cyan
        
        img.clipsToBounds = true
        return img
    }()
    
    let photoImageView: CustomImageView = {
        let img = CustomImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .cyan
        img.clipsToBounds = true
        return img
    }()
    
    let usernameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "userName"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    let optionsButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("•••", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    @objc
    func handleLike(){
        delegate?.onLikeTapped(for: self)
    }
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    @objc
    func handleComment(){
        print("Handle comment")
        guard let post = post else { return }
        delegate?.onCommentTapped(post: post)
        
    }
    
    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    //==========================================================
    // MARK:- Helper Methods
    //==========================================================
    func configureUI(){
        
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(optionsButton)
        addSubview(photoImageView)
        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        
        usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: photoImageView.topAnchor, right: optionsButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        optionsButton.anchor(top: topAnchor, left: nil, bottom: photoImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 0)
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        setupActionButtons()
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        
        
    }
    
    
    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
        
        addSubview(bookmarkButton)
        bookmarkButton.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 50)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
