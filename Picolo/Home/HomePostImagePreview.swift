//
//  HomePostImagePreview.swift
//  Picolo
//
//  Created by Kristopher Chayadi on 11/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import Foundation
import UIKit

class HomePostImagePreview: UIViewController, UIScrollViewDelegate{
    
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
    
    var scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.minimumZoomScale = 0.5
        sv.maximumZoomScale = 10.0
        sv.alwaysBounceHorizontal = false
        sv.alwaysBounceVertical = false
        sv.showsVerticalScrollIndicator = true
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotTaken), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        scrollView.delegate = self
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        let tapRecog = UITapGestureRecognizer(target: self, action: #selector(tapped))
        swipeGesture.direction = .down
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(tapRecog)
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(tapRecog)
        //photoImageView.addGestureRecognizer(swipeGesture)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        view.addSubview(scrollView)
        scrollView.addSubview(photoImageView)
        scrollView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        photoImageView.setAnchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    
}
