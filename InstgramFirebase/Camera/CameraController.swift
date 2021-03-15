//
//  CameraController.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 01/01/2021.
//  Copyright © 2021 Ahmad Eisa. All rights reserved.
//

import UIKit
import AVFoundation //To interact with Video and audio

class CameraController: UIViewController{
    
    //==========================================================
    // MARK:-Properties
    //==========================================================
    let customAnimationPresentor = CustomAnimationPresentor()
    let customAnimationDismisser = CustomAnimationDismisser()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    //==========================================================
    // MARK:- App Life Cycle
    //==========================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupCaptureSession()
        configureUI()
        
        transitioningDelegate = self
        
    }
   
    //==========================================================
    // MARK:- Helper Methods
    //==========================================================
    fileprivate func configureUI() {
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 50, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
    }
    
    
    //Prepare Our Camera
    let output = AVCapturePhotoOutput()
    fileprivate func setupCaptureSession() {
        //The session will coordinate the input and output data from the devices camera.
        let captureSession = AVCaptureSession()
        
        //1. setup inputs
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("Unable to access back camera!")
            return
            
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print("Error Unable to initialize back camera input:", error)
        }
        
        //2. setup outputs
       
   
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        //3. setup output preview
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = view.frame
        view.layer.addSublayer(videoPreviewLayer)
        
        captureSession.startRunning()// show what camera see
    }
    //==========================================================
    // MARK:- Selectors
    //==========================================================
    @objc func handleCapturePhoto() {
        print("Capturing photo...")
        
        let settings = AVCapturePhotoSettings()
        
        #if (!arch(x86_64))
            guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
            
            settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
            
            output.capturePhoto(with: settings, delegate: self)
        #endif
    }
    

    
}



//==========================================================
// MARK:- AVCapturePhotoCaptureDelegate
//==========================================================
extension  CameraController: AVCapturePhotoCaptureDelegate  {
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {

        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)

        let previewImage = UIImage(data: imageData!)
        
        let containerView = PreviewPhotoContainerView()
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        containerView.previewImageView.image = previewImage



        print("Finish processing photo sample buffer...")

    }
}

extension CameraController:  UIViewControllerTransitioningDelegate {
    
  
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresentor
            
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismisser
    }
}
