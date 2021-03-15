//
//  MainTabBarController.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 16/11/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//
import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    //    statusBarBackgroundColor()
        self.delegate = self // Delegate self to handle delegate methods.
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginVC = LoginController()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
           
            return
        }
        setUpViewControllers()
       
    }
    
    func setUpViewControllers() {
        let layout = UICollectionViewFlowLayout()
        //HomeController SetUp
        let homeNavController = templateNavController(image: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected")  , rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        //SearchController SetUp
        let searchNavController =  templateNavController(image: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected") ,rootViewController: UserSearchController(collectionViewLayout: layout))
        //plusNavController SetUp
        let plusNavController =  templateNavController(image: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        //likeNavController SetUp
        let likeNavController = templateNavController(image: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        //UserProfileController SetUp
       
        let userProfile = UserProfileController(collectionViewLayout: layout)
        //cmd + Ctrl + E ---> To Refractor name
        let userProfileNavController = UINavigationController(rootViewController: userProfile)
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        tabBar.tintColor = .black
        viewControllers = [  homeNavController,
                             searchNavController,
                             plusNavController,
                             likeNavController,
                             userProfileNavController
                             
                          ]
        
        //modify tab bar items insets
        guard let items = tabBar.items else { return }
        for item in items {
           item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            self.title = nil
        }
        
        
        
        
        
    }
    
    fileprivate func templateNavController(image: UIImage , selectedImage: UIImage , rootViewController: UIViewController = UIViewController())-> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
    return navController
    }
    
}



//==========================================================
// MARK:- UITabBarControllerDelegate
//==========================================================

//disable a particular UITabBar Item
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
      //  How to stop loading specific view controller on tabbar item selection?
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
               if selectedIndex == 2{
                   //Do anything.
                print("Don't Preview This View Controller")
           
                let layout = UICollectionViewFlowLayout()
                let photSelectorController = PhotoSelectorController(collectionViewLayout: layout)
                let navController = UINavigationController(rootViewController: photSelectorController)
                navController.modalPresentationStyle = .fullScreen
                 present(navController, animated: true, completion: nil)
                   return false
               }
               return true
           }
        
   
}
