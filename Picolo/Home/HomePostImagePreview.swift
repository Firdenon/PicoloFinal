//
//  HomePostImagePreview.swift
//  Picolo
//
//  Created by Kristopher Chayadi on 11/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import Foundation
import UIKit

class HomePostImagePreview: UIViewController{
    
    var post: Post?{
        didSet{
            guard let imageURL = post?.imageUrl else {return}
            photoImageView.loadImage(urlString: imageURL){
                
            }
        }
    }
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFit
        iv.frame = CGRect.zero
        iv.backgroundColor = .black
        iv.clipsToBounds = true
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotTaken), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        let tapRecog = UITapGestureRecognizer(target: self, action: #selector(tapped))
        swipeGesture.direction = .down
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(tapRecog)
        //photoImageView.addGestureRecognizer(swipeGesture)
        view.addSubview(photoImageView)
        photoImageView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func swiped(){
        print("Ke Swipe")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapped(){
        print("Tapped")
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func screenshotTaken(){
        print("Screenshot!")
    }
    
    
}
