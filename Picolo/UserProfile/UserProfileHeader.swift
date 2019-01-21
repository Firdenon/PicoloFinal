//
//  UserProfileHeader.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 07/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import Foundation
import UIKit

class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            
            guard let profileImageUrl = user?.profileImageUrl else {return}
            profileImageView.loadImage(urlString: profileImageUrl)
            descLabel.text = user?.username
            
            
            
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .lightGray
        return iv
    }()
    
//    let gridButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
////        btn.tintColor = UIColor(white: 0, alpha: 0.1)
//        return btn
//    }()
//
//    let listButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setImage(#imageLiteral(resourceName: "list"), for: .normal)
//        btn.tintColor = UIColor(white: 0, alpha: 0.3)
//        return btn
//    }()
//
//    let ribbonButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
//        btn.tintColor = UIColor(white: 0, alpha: 0.3)
//        return btn
//    }()
//
    let descLabel: UILabel = {
       let lb = UILabel()
        lb.text = "username"
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        return lb
    }()
    
    let postLabel: UILabel = {
        let lb = UILabel()
        
        let attributed = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.white])
        attributed.append(NSAttributedString(string: "post", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        lb.attributedText = attributed
        
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.backgroundColor = UIColor.rgb(red: 255, green: 150, blue: 123)
        return lb
    }()
    
    let followsLabel: UILabel = {
        let lb = UILabel()
        
        let attributed = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.white])
        attributed.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        lb.attributedText = attributed
        
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.backgroundColor = UIColor.rgb(red: 255, green: 150, blue: 123)
        return lb
    }()
    
    let followingLabel: UILabel = {
        let lb = UILabel()
        
       let attributed = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.white])
        attributed.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        lb.attributedText = attributed
        
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.backgroundColor = UIColor.rgb(red: 255, green: 150, blue: 123)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.setAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        profileImageView.layer.cornerRadius = 100 / 2
        profileImageView.clipsToBounds = true
        
        setupBottomToolbar()
        
        addSubview(descLabel)
        descLabel.setAnchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
    }
    
    fileprivate func setupBottomToolbar() {
        let stackview = UIStackView(arrangedSubviews: [postLabel,followsLabel,followingLabel])
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        addSubview(stackview)
        stackview.setAnchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
