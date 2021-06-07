//
//   Gesture Recognizers.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 05/04/2021.
//  Copyright © 2021 Ahmad Eisa. All rights reserved.
//

import UIKit

//https://medium.com/swlh/custom-gesture-recognizers-in-ios-15b72ed7a7e5

class TapGestureReplicator:UIGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        // Checking the count of touches .
        // If number of finger used in gesture is not equal to one , then gesture should fail.
        guard touches.count == 1 , let _ = touches.first else {
            self.state = .failed
            return
        }
        self.state = .began
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        guard touches.count == 1 , let _ = touches.first else {
            self.state = .failed
            return
        }
        self.state = .ended
    }
    
}

enum LikeGestureStatus {
    case unknown
    case fail
    case success
}

class LikeGestureRecognizer:UIGestureRecognizer {
    
    private var lastTouchTime:CFTimeInterval = CACurrentMediaTime()
    private(set) var status = LikeGestureStatus.unknown
    private(set) var doubleTapGestureThreshold:CFTimeInterval = 0.25
    
   /// Customize double-tap gesture recognizer timing
    // if time between continious taps is smaller than threshold value , then gesture succeed
    func setThreshold(threshold:CFTimeInterval) {
        self.doubleTapGestureThreshold = threshold
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
        self.status = .unknown
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        self.state = .changed
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        let currentTime = CACurrentMediaTime()
        let diff:CFTimeInterval = currentTime - lastTouchTime
        
        self.status = diff < doubleTapGestureThreshold ? LikeGestureStatus.success : LikeGestureStatus.fail
        self.state = .ended
        
        lastTouchTime = currentTime
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
    }
}


//override func viewDidLoad() {
//   super.viewDidLoad()
//   let likeGesture = LikeGestureRecognizer(target: self, action: #selector(handleLikeGesture(gesture:)))
//   self.viewGesture.addGestureRecognizer(likeGesture)
// }
//
// @objc private func handleLikeGesture(gesture:LikeGestureRecognizer) {
//        print("I never be called. You have to implement gesture recognizer's state setters")
// }
