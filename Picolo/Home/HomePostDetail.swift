//
//  HomePostDetail.swift
//  Picolo
//
//  Created by Kristopher Chayadi on 11/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit

class HomePostDetail: UIViewController{
    
    var post: Post?{
        didSet{
            guard let imageURL = post?.imageUrl else {return}
            photoImageView.loadImage(urlString: imageURL)
            
            titleLable.text = post?.title
            
            guard let usernameText = post?.user.username else {return}
            usernameLabel.text = "by " + (usernameText)
            
            guard let profileImageUrl = post?.user.profileImageUrl else {return}
            profileImageView.loadImage(urlString: profileImageUrl)
        }
    }
    
    var titleLable:UILabel = {
        let tl = UILabel()
        tl.text = "title"
        tl.font = UIFont(name: "Avenir-medium", size: 18)
        tl.textColor = UIColor.black
        return tl
    }()
    
    let usernameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "By username"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = UIColor.black
        return lb
    }()
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        return iv
    }()
    
    let arButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        btn.backgroundColor = .green
        btn.setTitle("AR Button", for: .normal)
        btn.addTarget(self, action: #selector(goToAR), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark Tap Recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageDetail))
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(tap)
        
        //mark View
        view.backgroundColor = .white
        view.addSubview(titleLable)
        view.addSubview(usernameLabel)
        view.addSubview(photoImageView)
        view.addSubview(profileImageView)
        view.addSubview(arButton)
        
        
        photoImageView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: 0,height: 200)
        profileImageView.setAnchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: 50,height: 50)
        titleLable.setAnchor(top: photoImageView.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        usernameLabel.setAnchor(top: titleLable.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        arButton.setAnchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    @objc func tapImageDetail(){
        print("1")
        let vc = HomePostImagePreview()
        vc.post = post
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func goToAR() {
        let arScene = HomePostDetailARSCN()
        arScene.post = post
        navigationController?.pushViewController(arScene, animated: true)
        
    }
}
