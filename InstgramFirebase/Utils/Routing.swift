//
//  Routing.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 08/12/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

//import Foundation
//import UIKit
//import CoreLocation
//
//class Routing {
//
//    class func decideInitialViewController(window:UIWindow){
//        let userDefaults = UserDefaults.standard
//        if((Routing.getUserDefault("isFirstRun")) == nil)
//        {
//            Routing.setAnimatedAsInitialViewContoller(window: window)
//        }
//        else if((userDefaults.object(forKey: "User")) != nil)
//        {
//            Routing.setHomeAsInitialViewContoller(window: window)
//        }
//        else
//        {
//            Routing.setLoginAsInitialViewContoller(window: window)
//        }
//
//    }
//
//    class func setAnimatedAsInitialViewContoller(window:UIWindow) {
//        Routing.setUserDefault("Yes", KeyToSave: "isFirstRun")
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let animatedViewController: AnimatedViewController = mainStoryboard.instantiateViewController(withIdentifier: "AnimatedViewController") as! AnimatedViewController
//
//        window.rootViewController = animatedViewController
//        window.makeKeyAndVisible()
//    }
//
//    class func setHomeAsInitialViewContoller(window:UIWindow) {
//        let userDefaults = UserDefaults.standard
//        let decoded  = userDefaults.object(forKey: "User") as! Data
//        User.currentUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! User
//
//        if(User.currentUser.userId != nil && User.currentUser.userId != "")
//        {
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let homeViewController: HomeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//            let loginViewController: UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
//            loginViewController.viewControllers.append(homeViewController)
//            window.rootViewController = loginViewController
//        }
//        window.makeKeyAndVisible()
//    }
//
//    class func setLoginAsInitialViewContoller(window:UIWindow) {
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let loginViewController: UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
//
//        window.rootViewController = loginViewController
//        window.makeKeyAndVisible()
//    }
//
//  class func setUserDefault(_ ObjectToSave : Any?  , KeyToSave : String)
//    {
//        let defaults = UserDefaults.standard
//
//        if (ObjectToSave != nil)
//        {
//
//            defaults.set(ObjectToSave, forKey: KeyToSave)
//        }
//
//        UserDefaults.standard.synchronize()
//    }
//
//    class func getUserDefault(_ KeyToReturnValye : String) -> Any?
//    {
//        let defaults = UserDefaults.standard
//
//        if let name = defaults.value(forKey: KeyToReturnValye)
//        {
//            return name as Any
//        }
//        return nil
//    }
//
//    class func removetUserDefault(_ KeyToRemove : String)
//    {
//        let defaults = UserDefaults.standard
//        defaults.removeObject(forKey: KeyToRemove)
//        UserDefaults.standard.synchronize()
//    }
//
//}


//And in your AppDelegate call this
//self.window = UIWindow(frame: UIScreen.main.bounds)
// Routing.decideInitialViewController(window: self.window!)
