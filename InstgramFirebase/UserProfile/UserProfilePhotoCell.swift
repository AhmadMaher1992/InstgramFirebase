//
//  UserProfilePhotoCell.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 21/12/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    
    var post: Post?{
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: imageUrl)
            
        }
    }
    
    let photoImageView: CustomImageView = {
        let img = CustomImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        photoImageView.constraints(to: contentView, left: leftAnchor, right: rightAnchor, top: topAnchor, bottom: bottomAnchor, paddingLeft: 0, paddingRight: 0, paddingTop: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
