//
//  CustomImageView.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 22/12/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//


import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        print("🤗Loading image...")
        
        lastURLUsedToLoadImage = urlString
        self.image = nil
        if let cashImage = imageCache[urlString]{
            self.image = cashImage
        }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
    }
}


//
//
//@IBAction func upload(_ sender: Any) {
//checkExist(url: inserttheurlhere){ succes in
//if succes{
////image exist
////continue your work here when the picture exist
//}else{
////error downloading, not exist or other failure
////continue your work here when no exist
//}
//
//    let storageRef = Storage.storage().reference().child("images/\(NSUUID().uuidString)/image.png")
//    if let uploadData = UIImagePNGRepresentation(self.myImageView1.image!){
//    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//
//
//
//        let storageRef2 = Storage.storage().reference().child("images2/\(NSUUID().uuidString)/image2.png")
//        if let uploadData2 = UIImagePNGRepresentation(self.myImageView2.image!){
//        storageRef2.putData(uploadData2, metadata: nil, completion: { (metadataSecond, error) in
//
//
//
//                if error != nil {
//                        print("error")
//                        return
//
//                    } else {
//                        let downloadURL = metadata?.downloadURL()?.absoluteString
//                        let downloadURL2 = metadataSecond?.downloadURL()?.absoluteString
//
//                        self.ref?.child("Posts").childByAutoId().setValue(["Title": self.titleText.text, "Subtitle": self.subtitleText.text, "Article": self.articleText.text, "Author": self.authorText.text, "Date": self.dateText.text, "Tags": self.tagsText.text, "PostType": self.postType.text, "PostStyle": self.postStyle.text, "PostSize": self.postSize.text, "Download URL": (downloadURL), "Download URL 2": (downloadURL2)])
//
//            }
//
//func checkExist(url: String, completionHandler:@escaping (Bool) -> ()){
//let storageRef = Storage.storage().reference().child(url)
//        if let uploadData = UIImagePNGRepresentation(self.theuiview.image!){
//        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//if error == nil && metadata != nil{
//completionHandler(true)
//}else{
//completionHandler(false)
//}
//})
//}
