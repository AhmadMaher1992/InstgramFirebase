//
//  StatusBar.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 29/12/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension UIViewController{
    func statusBarBackgroundColor() {
           if #available(iOS 13, *)
           {
               let statusBar = UIView(frame: (UIWindow.key?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor =  .white
               UIWindow.key?.addSubview(statusBar)
           } else {
               // ADD THE STATUS BAR AND SET A CUSTOM COLOR
               let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
               if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor =  .white
               }
           }
       }
    
    func hideStatusBarBackground() {
         UIWindow.key?.subviews.forEach({$0.backgroundColor = .clear})
    }
}
