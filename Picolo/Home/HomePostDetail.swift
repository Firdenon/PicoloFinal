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
            photoImageView.loadImage(urlString: imageURL){
                
            }
            titleLable.text = post?.title
            guard let usernameText = post?.user.username else {return}
            guard let postUserId = post?.user.uid else {return}
            let uid = Auth.auth().currentUser?.uid
            
            if postUserId == uid {
                usernameLabel.text = "by me"
            } else {
                usernameLabel.text = "by " + (usernameText)
                print(usernameLabel.text)
            }
            guard let profileImageUrl = post?.user.profileImageUrl else {return}
            profileImageView.loadImage(urlString: profileImageUrl){
                DispatchQueue.main.async {
                    self.arButton.isEnabled = true
                }
            }
            
            descriptionText.text = post?.description ?? "No Description"
            
            likeButton.setImage(post?.hasLiked == true ? #imageLiteral(resourceName: "Shape copy").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "Shape").withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    var loaded:Bool = false
    var likeCount:Int? {
        didSet{
            DispatchQueue.main.async {
                self.likeLable.text = self.likeCount?.description
            }
        }
    }
    
    var commentCount:Int?
    
    var titleLable:UILabel = {
        let tl = UILabel()
        tl.text = "title"
        tl.font = UIFont(name: "Avenir-medium", size: 14)
        tl.textColor = UIColor.black
        return tl
    }()
    
    var likeLable:UILabel = {
        let tl = UILabel()
        tl.text = "0"
        tl.font = UIFont(name: "Avenir-medium", size: 18)
        tl.textColor = UIColor.black
        return tl
    }()
    
    var commentLable:UILabel = {
        let tl = UILabel()
        tl.text = "title"
        tl.font = UIFont(name: "Avenir-medium", size: 18)
        tl.textColor = UIColor.black
        return tl
    }()
    
    let usernameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "By username"
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textColor = UIColor.black
        return lb
    }()
    
    let descriptionText: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = true
        tv.textAlignment = .left
        tv.textColor = UIColor.orange
        tv.font = UIFont(name:"Avenir-medium",size:16)
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.isSelectable = false
        tv.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus aliquam nisl at tortor egestas vestibulum. Mauris egestas dui id nisl viverra finibus. Sed finibus, justo eu scelerisque interdum, enim lorem congue est, ac sagittis diam velit in erat. Vivamus ac sagittis augue. Phasellus dapibus ligula facilisis hendrerit porttitor. Sed eget convallis sapien. In hac habitasse platea dictumst."
        return tv
    }()
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .white
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
        btn.setImage(#imageLiteral(resourceName: "ARKit_Glyph_Button (1)"), for: .normal)
        btn.addTarget(self, action: #selector(goToAR), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    let likeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "Shape").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handelLike), for: .touchUpInside)
        return btn
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if photoImageView.image != nil {
            arButton.isEnabled = true
        }
    }
    
    func fetchLikeCount(){
        guard let postId = post?.id else {return}
        Database.database().reference().child("likeCount").child(postId).observeSingleEvent(of: .value) { (snapshot) in
            if let counts = snapshot.value as? [String: Any] {
                print(counts)
                self.likeCount = counts["likesCount"] as? Int
                print("Like Count : \(self.likeCount)")
            }
        }
    }
    
    @objc func handelLike() {
        print("liked")
        guard let postId = post?.id else {return}
        
        if Auth.auth().currentUser == nil {
            let loginView = LoginController()
            let navLogin = UINavigationController(rootViewController: loginView)
            present(navLogin, animated: true, completion: nil)
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = [uid:post?.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (err, _) in
            if let err = err {
                print("Failed to like post: \(err.localizedDescription)")
                return
            }
            
            let moreRef = Database.database().reference().child("likeCount").child(postId)
            moreRef.runTransactionBlock({ (currentData) -> TransactionResult in
                if var data = currentData.value as? [String:Any] {
                    var count = data["likesCount"] as! Int
                    if self.post?.hasLiked == true {
                        count += 1
                        if self.likeCount == nil {
                            self.likeCount = count
                        } else {
                            self.likeCount! += 1
                        }
                    } else {
                        count -= 1
                        if self.likeCount == nil {
                            self.likeCount = count
                        } else {
                            self.likeCount! -= 1
                        }
                    }
                    data["likesCount"] = count
                    currentData.value = data
                    return TransactionResult.success(withValue: currentData)
                }
                return TransactionResult.success(withValue: currentData)
            })
            print("Succesfully liked post")
            
            self.post?.hasLiked = !(self.post?.hasLiked)!
        }
    }
    
    let commentButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "Comment").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return btn
    }()
    let commentButton2: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "Comment").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleComment() {
        if Auth.auth().currentUser == nil {
            let loginView = LoginController()
            let navLogin = UINavigationController(rootViewController: loginView)
            present(navLogin, animated: true, completion: nil)
            return
        }
        
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
        view.addSubview(descriptionText)
        
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(commentButton2)
        
        view.addSubview(likeLable)
        view.addSubview(commentLable)
        
        photoImageView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width : view.frame.width, height: ((post?.imageHeight)!) * (view.frame.width / ((post?.imageHeight)!)))
        
        profileImageView.setAnchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop:20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0,width: 50,height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.clipsToBounds = true
        
        titleLable.setAnchor(top: photoImageView.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 6.5, paddingBottom: 0, paddingRight: 0)
        
        usernameLabel.setAnchor(top: titleLable.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 9, paddingBottom: 0, paddingRight: 0)
        
        arButton.setAnchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 20)
        
        likeButton.setAnchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        
        commentButton.setAnchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 101, paddingBottom: 0, paddingRight: 0)
        commentButton2.setAnchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 101, paddingBottom: 0, paddingRight: 0)
        
        likeLable.setAnchor(top: profileImageView.bottomAnchor, left: likeButton.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        
        descriptionText.setAnchor(top: commentButton2.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 103, paddingRight: 20)
        
        fetchLikeCount()
        
    }
    
    @objc func tapImageDetail(){
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
