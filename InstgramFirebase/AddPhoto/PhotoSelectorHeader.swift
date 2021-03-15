//
//  PhotoSelectorHeader.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 13/12/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit

class PhotoSelectorHeader: UICollectionViewCell {
    
    
    let photoImageView: UIImageView = {
        let im = UIImageView()
        im.clipsToBounds = true
        im.contentMode = .scaleToFill
        im.backgroundColor = .white
        return im
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    func configureUI(){
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0 )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
