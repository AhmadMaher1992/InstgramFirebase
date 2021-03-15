//
//  AppDelegate.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 6/14/20.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        window = UIWindow()
        window?.rootViewController = MainTabBarController()
        // MARK: Navigation Bar Customisation
       
        // Sets background to a blank/empty image
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default )
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        //Remove Back KeyWord
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)
        // Title text color Black => Text appears in white
        UINavigationBar.appearance().barStyle = .blackOpaque

           // Translucency; false == opaque
        UINavigationBar.appearance().isTranslucent = false

           // Foreground color of bar button item text, e.g. "< Back", "Done", and so on.
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // BACKGROUND color of nav bar
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        UINavigationBar.appearance().clipsToBounds = false
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        return true
    }
    
   
    func applicationWillResignActive(_ application: UIApplication) {
      
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
      
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
      
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
   
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
       
    }
    
    
}


//
/// Set navigation bar tint / background colour
//UINavigationBar.appearance().barTintColor = UIColor.redColor()
//
//// Set Navigation bar Title colour
//UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
//

//

//
////Set navigation bar Back button tint colour
//UINavigationBar.appearance().tintColor = UIColor.whiteColor()
//
//or you can also access UINavigationBar through the UINavigationController and change UINavigationBar tint color For example:
//

//
//// Set navigation bar title text colour
//self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
//


//
//// -----------------------------------------------------------
//// NAVIGATION BAR CUSTOMIZATION
//// -----------------------------------------------------------
//self.navigationController?.navigationBar.prefersLargeTitles = true
//self.navigationController?.navigationBar.tintColor = UIColor.white
//self.navigationController?.navigationBar.isTranslucent = false
//
//if #available(iOS 13.0, *) {
//    let appearance = UINavigationBarAppearance()
//    appearance.configureWithDefaultBackground()
//    appearance.backgroundColor = UIColor.blue
//    appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//    appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//
//    navigationController?.navigationBar.standardAppearance = appearance
//    navigationController?.navigationBar.scrollEdgeAppearance = appearance
//    navigationController?.navigationBar.compactAppearance = appearance
//
//} else {
//    self.navigationController?.navigationBar.barTintColor = UIColor.blue
//    self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//}
//
//// -----------------------------------------------------------
//// NAVIGATION BAR SHADOW
//// -----------------------------------------------------------
//self.navigationController?.navigationBar.layer.masksToBounds = false
//self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
//self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
//self.navigationController?.navigationBar.layer.shadowRadius = 15
//self.navigationController?.navigationBar.layer.shadowOpacity = 0.7

//
//if let url = URL(string: model.url){
//   let placeholder = UIImage(named:"placeholder")
//    let options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
//    image.kf.indicatorType = .activity
//    image.kf.setImage(with: url  , placeholder: placeholder,options: options )
//}
