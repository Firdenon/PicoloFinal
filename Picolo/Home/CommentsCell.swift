//
//  CommentsCell.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 24/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit

class CommentsCell: UICollectionViewCell {
    
    var comment: Comment?{
        didSet{
            guard let comment = comment else {return}
            let attributedText = NSMutableAttributedString(string: comment.user.username + "\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: comment.text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            textView.attributedText = attributedText
            profileImageView.loadImage(urlString: comment.user.profileImageUrl){
                
            }
        }
    }
    
    let textView : UITextView  = {
        let tx = UITextView()
        tx.font = UIFont.boldSystemFont(ofSize: 14)
        tx.isScrollEnabled = false
        return tx
    }()
    
    let profileImageView: CustomImageView = {
        let pv = CustomImageView()
        pv.clipsToBounds = true
        pv.contentMode = .scaleAspectFill
        pv.backgroundColor = .lightGray
        return pv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.setAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        
        addSubview(textView)
        textView.setAnchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 10, paddingBottom: 4, paddingRight: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
