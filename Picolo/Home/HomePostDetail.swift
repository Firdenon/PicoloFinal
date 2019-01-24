//
//  HomePostDetail.swift
//  Picolo
//
//  Created by Kristopher Chayadi on 11/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit
import Firebase

class HomePostDetail: UIViewController{
    
    var post: Post?{
        didSet{
            guard let imageURL = post?.imageUrl else {return}
            photoImageView.loadImage(urlString: imageURL)
            titleLable.text = post?.title
            guard let usernameText = post?.user.username else {return}
            guard let postUserId = post?.user.uid else {return}
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            if postUserId == uid {
                usernameLabel.text = "by me"
            } else {
                usernameLabel.text = "by " + (usernameText)
            }
            guard let profileImageUrl = post?.user.profileImageUrl else {return}
            profileImageView.loadImage(urlString: profileImageUrl)
            
            likeButton.setImage(post?.hasLiked == true ? #imageLiteral(resourceName: "Done").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like ").withRenderingMode(.alwaysOriginal), for: .normal)
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
    
    let likeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "like ").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handelLike), for: .touchUpInside)
        return btn
    }()
    
    @objc func handelLike() {
        print("liked")
        guard let postId = post?.id else {return}
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = [uid:post?.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (err, _) in
            if let err = err {
                print("Failed to like post: \(err.localizedDescription)")
                return
            }
            
            print("Succesfully liked post")
            
            self.post?.hasLiked = !(self.post?.hasLiked)!
        }
    }
    
    let commentButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleComment() {
        print("handle Comment")
        
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
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
        
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        
        photoImageView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: 0,height: 200)
        profileImageView.setAnchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: 50,height: 50)
        titleLable.setAnchor(top: photoImageView.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        usernameLabel.setAnchor(top: titleLable.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        arButton.setAnchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        likeButton.setAnchor(top: arButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        
        commentButton.setAnchor(top: likeButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        
    }
    
    @objc func tapImageDetail(){
        print("1")
        let vc = HomePostImagePreview()
        vc.post = post
        navigationController?.pushViewController(vc, animated: true)
        
        //self.present(vc, animated: true, completion: nil)
    }
    
    @objc func goToAR() {
        let arScene = HomePostDetailARSCN()
        arScene.post = post
        navigationController?.pushViewController(arScene, animated: true)
        
    }
}
