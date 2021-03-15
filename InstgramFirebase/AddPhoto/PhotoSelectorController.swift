//
//  PhotoSelectorController.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 11/12/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit
import Photos
class PhotoSelectorController: UICollectionViewController {
    
    
    
    let cellID = "cellID"
    let headerID = "headerID"
    var images = [UIImage]()
    var selectedImage: UIImage?
    var assests = [PHAsset]()
    var header: PhotoSelectorHeader?
    
    //Hide Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchPhotos()
        
    }
    
    func configureCollectionView(){
        
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        setupNavigationButtons()
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:headerID)
    }
    
    fileprivate func fetchPhotos(){
        print("fetchPhotos")
        /// Load Photos
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        // .highQualityFormat will return better quality photos
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        //do fetching photos in background
        DispatchQueue.global(qos: .background).async {
            
            if results.count > 0 {
                for i in 0..<results.count {
                    let asset = results.object(at: i)
                    let targetSize = CGSize(width: 200 , height: 200)
                    manager.requestImage(for: asset, targetSize: targetSize, contentMode: .default, options: requestOptions) { (image, _) in
                        if let image = image {
                            self.images.append(image)
                            self.assests.append(asset)
                            if  self.selectedImage == nil {
                                self.selectedImage = image
                            }
                            //go to main thread to update ui
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                            
                        } else {
                            print("error asset to image")
                        }
                    }
                }
            } else {
                print("no photos to display")
            }
            
        }
        
    }
    
    fileprivate func setupNavigationButtons(){
        let leftBarItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = leftBarItem
        let rightBarItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        navigationItem.rightBarButtonItem = rightBarItem
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = .black
        
    }
    
    @objc
    fileprivate func handleCancel(){
        dismiss(animated: true) {
            print("Dismiss PhotoSelector Controller")
        }
    }
    @objc
    fileprivate func handleNext(){
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedImage = header?.photoImageView.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    
    
}


//==========================================================
// MARK:- Collection View Delegate And Data Source
//==========================================================


extension PhotoSelectorController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoSelectorCell
        let image = images[indexPath.item]
        cell.photoImageView.image = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ( view.frame.width - 3  ) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //Create Header For our collection
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! PhotoSelectorHeader
        self.header = header
        if let selectedImage = selectedImage {
            if let index = self.images.firstIndex(of: selectedImage){
                let selectedAssest = self.assests[index]
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAssest, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                    
                    header.photoImageView.image = image
                    
                }
            }
        }
        
        
        
        return header
    }
    
    //you must give header size to render
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1 , left: 0, bottom: 0, right: 0)
    }
    
    
    //did select row
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = images[indexPath.item]
        collectionView.reloadData()
        //scroll our collection to first item when select photo
        let indexPath = IndexPath(item: 0, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        
    }
    
}


