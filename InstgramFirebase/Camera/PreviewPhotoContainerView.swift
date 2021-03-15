//
//  PreviewPhotoContainerView.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 21/02/2021.
//  Copyright © 2021 Ahmad Eisa. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    
    lazy var savedLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Saved Successfully"
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.textColor = .white
        lbl.numberOfLines = 0 //wrap text to another line if necessary
        lbl.textAlignment = .center
        lbl.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return lbl
    }()
    
    let previewImageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    let cancelBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "cancel_shadow-1").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return btn
    }()
    
    
    
    @objc
    func handleCancel(){
        self.removeFromSuperview()
        
    }
    
    let saveBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return btn
    }()
    
    
    @objc
    func handleSave(){
        //photo library reference
        guard let previewImage = previewImageView.image else { return }
        let library = PHPhotoLibrary.shared()
        library.performChanges {
            
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
            
        } completionHandler: { (success, error) in
            if let error = error {
                print("DEBUG: Failed to Save Photo to Photo Library: ",error)
                return
            }
     print("DEBUG: Successfuly Saved Photo To Library")
            DispatchQueue.main.async {
                self.savedLbl.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
                self.savedLbl.center = self.center
                self.addSubview(self.savedLbl)
                self.savedLbl.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
                    self.savedLbl.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    
                }, completion: { (completed) in
                    //completed
                    
                    UIView.animate(withDuration: 0.5, delay: 0.8, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        
                        self.savedLbl.layer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
                        self.savedLbl.alpha = 0
                        
                    }, completion: { (_) in
                        
                        self.savedLbl.removeFromSuperview()
                        
                    })
                    
                })

            }
           
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //==========================================================
    // MARK:- Helper Methods
    //==========================================================
    func configureUI(){
        backgroundColor = .yellow
        previewImageView.constraints(to: self, left: leftAnchor, right: rightAnchor, top: topAnchor, bottom: bottomAnchor, paddingLeft: 0, paddingRight: 0, paddingTop: 0, paddingBottom: 0, width: 0, height: 0)
        cancelBtn.constraints(to: self, left: leftAnchor, right: nil, top: self.safeAreaLayoutGuide.topAnchor, bottom: nil, paddingLeft: 12, paddingRight: 0, paddingTop: 12, paddingBottom: 0, width: 50, height: 50)
        saveBtn.constraints(to: self, left: leftAnchor, right: nil, top: nil, bottom: self.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 24, paddingRight: 0, paddingTop: 0, paddingBottom: 12, width: 50, height: 50)
        
    }
}
