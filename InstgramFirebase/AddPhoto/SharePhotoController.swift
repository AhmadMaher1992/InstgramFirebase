//
//  SharePhotoController.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 21/12/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit
import Firebase
class SharePhotoController: UIViewController {
    
    
    
    static let updateFieldNotificationName = NSNotification.Name(rawValue: "UpdateField")
    
    var selectedImage: UIImage? {
        
        didSet {
            guard let selectedImage = selectedImage else { return }
            self.imageView.image = selectedImage
        }
        
        
    }
    
    let imageView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .red
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
        
    }()
    
    let textView: UITextView = {
        let txt = UITextView()
        txt.font = UIFont.systemFont(ofSize: 14)
        return txt
    }()
    
    
    
    override var prefersStatusBarHidden: Bool {
        return  true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        let rightbarItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        navigationItem.rightBarButtonItem = rightbarItem
        setupImagesAndTextViews()
    }
    
    fileprivate func setupImagesAndTextViews(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 85, height: 0)
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    
    @objc
    func handleShare(){
        guard let caption = textView.text , caption.count > 0 else { return }
        guard let uploadImage = selectedImage else { return}
        guard let uploadData = uploadImage.jpegData(compressionQuality: 0.1) else { return }
        //disable share button
        navigationItem.rightBarButtonItem?.isEnabled = false
        //create random strings
        let fileName = NSUUID().uuidString
        let ref =  Storage.storage().reference().child("posts").child(fileName)
        let sv = self.displaySpinner(onView: self.view)
        ref.putData(uploadData, metadata: nil) { (metaData, error) in
            if let error = error {
                print("error",error)
                self.removeSpinner(spinner: sv)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            ref.downloadURL{ (url, error) in
                
                if let error = error {
                    print("Unable to get Url ERROR" , error)
                    self.removeSpinner(spinner: sv)
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    DispatchQueue.main.async {
                        self.alert(message: error .localizedDescription, title: "Error")
                    }
                    return
                }
                let UrlString = url?.absoluteString
                guard let imageUrl = UrlString else { return }
                self.saveToDataBaseWithImageUrl(imageUrl: imageUrl)
                self.removeSpinner(spinner: sv)
            }
            
        }
    }
    
    
    fileprivate func saveToDataBaseWithImageUrl(imageUrl: String){
        guard let caption = textView.text else { return }
        guard let postImage = selectedImage else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref =  userPostRef.childByAutoId()
        let values: [String : Any] = ["imageUrl": imageUrl ,
                                      "caption": caption ,
                                      "imageWidth": postImage.size.width ,
                                      "imageHeight": postImage.size.height ,
                                      "creationDate": Date().timeIntervalSince1970
        ]
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                self.alert(message: error.localizedDescription, title: "Failed To Save Post To DB")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
            
            
            NotificationCenter.default.post(name: SharePhotoController.updateFieldNotificationName, object: nil)
        }
        
        
    }
}

