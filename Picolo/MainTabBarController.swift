//
//  MainTabBarController.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 07/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        let index = tabBarController.viewControllers?.index(of: viewController)
        if index == 2 {
            
            let layout = UICollectionViewFlowLayout()
            layout.sectionHeadersPinToVisibleBounds = true
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            
            present(navController, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        setupViewControllers()
    }
    
    func setupViewControllers() {
        
        //Home
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "gear"), selectedImage: #imageLiteral(resourceName: "profile_unselected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //Subscription
        let subNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "ribbon"), selectedImage: #imageLiteral(resourceName: "list"))
        
        //Upload Photo
        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "gear"), selectedImage: #imageLiteral(resourceName: "ribbon"))
        
        //User Profile
        let layout = UICollectionViewFlowLayout()
        //let layout = CustomLayout()
        let userProfileViewController = UserProfileViewController(collectionViewLayout: layout)
        let userProfileNavController = UINavigationController(rootViewController: userProfileViewController)
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = UIColor.rgb(red: 255, green: 150, blue: 123)
        
        viewControllers = [homeNavController,
                           subNavController,
                           plusNavController,
                           userProfileNavController]
        
        //modify tab bar item insets
        guard let items = tabBar.items else {return}
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
