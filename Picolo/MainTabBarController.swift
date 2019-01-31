//
//  MainTabBarController.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 07/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit
import Firebase
import PinterestLayout

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var isLogin: Bool = false
    
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        let index = tabBarController.viewControllers?.index(of: viewController)
//        if index == 2 {
//            let layout = UICollectionViewFlowLayout()
//            layout.sectionHeadersPinToVisibleBounds = true
//            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
//            let navController = UINavigationController(rootViewController: photoSelectorController)
//            present(navController, animated: true, completion: nil)
//            return false
//        }
//        return true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if Auth.auth().currentUser == nil {
            isLogin = false
//            DispatchQueue.main.async {
//                let loginController = LoginController()
//                let navController = UINavigationController(rootViewController: loginController)
//                self.present(navController, animated: true, completion: nil)
//            }
            setupViewControllers()
        } else {
            isLogin = true
            setupViewControllers()
        }
        print(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
    

    
    func setupViewControllers() {
        //Home
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "Explore Unselected"), selectedImage: #imageLiteral(resourceName: "Explore Selected"), rootViewController: HomeController(collectionViewLayout: PinterestLayout()))
        //Subscription
        let subNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "Following Unselected"), selectedImage: #imageLiteral(resourceName: "Following Selected"), rootViewController: SubscriptionController(collectionViewLayout: PinterestLayout()))
        //Upload Photo
        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "Upload Unselected"), selectedImage: #imageLiteral(resourceName: "plus_photo"))
        //User Profile
        
        
        let userProfileViewController = UserProfileViewController(collectionViewLayout: PinterestLayout())
        
        
        let userProfileNavController = UINavigationController(rootViewController: userProfileViewController)
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "Profile Unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "Profile Selected")
        
        
        let loginNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "gear"), selectedImage: #imageLiteral(resourceName: "noun_Tag_1948126 Copy"), rootViewController: AuthBoarding())
        
        
        tabBar.tintColor = UIColor.rgb(red: 255, green: 150, blue: 123)
        
        if isLogin {
            viewControllers = [homeNavController,
                               subNavController,
                               plusNavController,
                               userProfileNavController]
        } else {
            viewControllers = [homeNavController, loginNavController]
        }
        
        //modify tab bar item insets
        guard let items = tabBar.items else {return}
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
