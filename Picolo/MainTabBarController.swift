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
    var prevController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if Auth.auth().currentUser == nil {
            isLogin = false
            setupViewControllers()
        } else {
            isLogin = true
            setupViewControllers()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
    

    
    func setupViewControllers() {
        //Home
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "Explore Unselected"), selectedImage: #imageLiteral(resourceName: "Explore Selected"), rootViewController: HomeController(collectionViewLayout: PinterestLayout()))
        
        //Subscription
        let subNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "Following Unselected"), selectedImage: #imageLiteral(resourceName: "Following Selected"), rootViewController: SubscriptionController(collectionViewLayout: PinterestLayout()))
        
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
