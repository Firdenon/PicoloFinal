//
//  HomePostCell.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 08/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import Foundation
import UIKit

class HomePostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet{
            guard let imagePostUrl = post?.imageUrl else {return}
            photoImageView.loadImage(urlString: imagePostUrl)
            
            
            guard let usernameText = post?.user.username else {return}
            usernameLabel.text = "by " + (usernameText)
            
            guard let profileImageUrl = post?.user.profileImageUrl else {return}
            userProfileView.loadImage(urlString: profileImageUrl)
            
            titleLabel.text = post?.title
        }
    }
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        return iv
    }()
    
    let postContainer: UIView = {
        let uw = UIView()
        uw.backgroundColor = UIColor(white: 0.2, alpha: 0.4)
        return uw
    }()
    
    let userProfileView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Title"
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.textColor = UIColor.white
        return lb
    }()
    
    let usernameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "By username"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = UIColor.white
        return lb
    }()
    
    let likeButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "like ").withRenderingMode(.alwaysOriginal), for: .normal)
        return bt
    }()
    
    let likeLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        
        let attributed = NSMutableAttributedString(string: "500", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.white])
        
        lb.attributedText = attributed
        return lb
    }()
    
    let timeLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = .white
        lb.text = "1 day ago"
        return lb
    }()
    
    let saveButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    fileprivate func setupView() {
        addSubview(photoImageView)
        photoImageView.setAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: 0,height: 200)
        
        addSubview(postContainer)
        postContainer.setAnchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        postContainer.addSubview(userProfileView)
        postContainer.addSubview(titleLabel)
        postContainer.addSubview(usernameLabel)
        postContainer.addSubview(likeButton)
        postContainer.addSubview(likeLabel)
        postContainer.addSubview(timeLabel)
        postContainer.addSubview(saveButton)
        
        userProfileView.setAnchor(top: postContainer.topAnchor, left: postContainer.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 40,height: 40)
        userProfileView.layer.cornerRadius = 40 / 2
        
        titleLabel.setAnchor(top: userProfileView.topAnchor, left: userProfileView.rightAnchor, bottom: nil, right: postContainer.rightAnchor, paddingTop: 6, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 15)
        
        usernameLabel.setAnchor(top: titleLabel.bottomAnchor, left: userProfileView.rightAnchor, bottom: nil, right: postContainer.rightAnchor, paddingTop: 2, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 15)
        
        likeButton.setAnchor(top: userProfileView.bottomAnchor, left: postContainer.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 22, height: 22)
        
        likeLabel.setAnchor(top: likeButton.topAnchor, left: likeButton.rightAnchor, bottom: nil, right: postContainer.rightAnchor, paddingTop: 3, paddingLeft: 8, paddingBottom: 0, paddingRight: 8)
        
        timeLabel.setAnchor(top: nil, left: postContainer.leftAnchor, bottom: postContainer.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 15)
        
        saveButton.setAnchor(top: nil, left: nil, bottom: postContainer.bottomAnchor, right: postContainer.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 10, width: 22, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
