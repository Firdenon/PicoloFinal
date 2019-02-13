//
//  SubcriptionController.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 23/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit
import Firebase
import PinterestLayout

class SubscriptionController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SubscriptionHeaderDelegate {
    
    func allAction() {
        let followingList = FollowingListController(collectionViewLayout: UICollectionViewFlowLayout())
        followingList.users = userFollow
        navigationController?.pushViewController(followingList, animated: true)
    }
    
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var posts = [Post](){
        didSet{
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    var userFollow = [User]()
    
    let mask: UIView = {
        
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        
        let boardImage: UIImageView = {
            let iv = UIImageView()
            iv.image = #imageLiteral(resourceName: "Group 4").withRenderingMode(.alwaysOriginal)
            return iv
        }()
        
        let boardTitle: UILabel = {
            let lb = UILabel()
            lb.text = "You are not follow anyone. Let's follow!" + "\n" + "It would be nice if you" + "\n" + "connected with each other."
            lb.font = UIFont(name:"Avenir-medium",size:18)
            lb.textColor = UIColor.rgb(red: 255, green: 150, blue: 123)
            lb.numberOfLines = 0
            lb.textAlignment = .center
            return lb
        }()
        
        let ms = UIView()
        
        ms.addSubview(boardImage)
        boardImage.setAnchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 172, height: 169)
        boardImage.centerXAnchor.constraint(equalTo: ms.centerXAnchor).isActive = true
        boardImage.centerYAnchor.constraint(equalTo: ms.centerYAnchor, constant: -130).isActive = true
        
        ms.addSubview(boardTitle)
        boardTitle.setAnchor(top: boardImage.bottomAnchor, left: ms.leftAnchor, bottom: nil, right: ms.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width:0 , height: 100)
        
        ms.backgroundColor = .white
        return ms
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(SubscriptionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(SubscriptionPost.self, forCellWithReuseIdentifier: cellId)
        
        let refresControl = UIRefreshControl()
        refresControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresControl
        
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
            layout.cellPadding = 10
            layout.numberOfColumns = 2
        }
        fetchAllPost()
    }
    
    @objc func handleRefresh() {
        print("Handle Refresh.....")
        posts.removeAll()
        userFollow.removeAll()
        fetchAllPost()
    }
    
    fileprivate func fetchAllPost() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdDict = snapshot.value as? [String:Any] else {
                self.collectionView.refreshControl?.endRefreshing()
                return
            }
            userIdDict.forEach({ (key, value) in
                Database.fetchUserWithUid(uid: key, completion: { (user) in
                    self.userFollow.append(user)
                    self.userFollow.sort(by: { (u1, u2) -> Bool in
                        return u1.username.compare(u2.username) == .orderedAscending
                    })
                    self.fetchPostWithUser(user: user)
                })
            })
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
            
        }) { (err) in
            print("Failed to fetch all user id: \(err)")
        }
    }
    
    fileprivate func fetchPostWithUser(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            self.collectionView.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String:Any] else {return}
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String:Any] else {return}
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else {return}
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView.refreshControl?.endRefreshing()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                }, withCancel: { (err) in
                    self.collectionView.refreshControl?.endRefreshing()
                    print("Failed to fetch like info for post")
                })
            })
        }) { (err) in
            self.collectionView.refreshControl?.endRefreshing()
            print("Failed to fetch post: \(err.localizedDescription)")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.posts.count == 0 {
            self.collectionView.backgroundView = mask
        } else {
            self.collectionView.backgroundView = nil
        }
        
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SubscriptionPost
        cell.post = posts[indexPath.item]
        cell.backgroundColor = .lightGray
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.1)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.clipsToBounds = false
        cell.layer.cornerRadius = 20
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = HomePostDetail()
        detail.post = posts[indexPath.item]
        navigationController?.pushViewController(detail, animated: true)
    }
    
}

extension SubscriptionController: PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let imageHeight = posts[indexPath.item].imageHeight
        let imageWidth = posts[indexPath.item].imageWidth
        let lebaryangditentukan:CGFloat = (375 / 2) - 20
        let x = imageWidth / lebaryangditentukan
        let panjang = imageHeight / x
        return panjang
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SubscriptionHeader
        header.user = userFollow
        header.delegate = self
        return header
    }
    
    func collectionView(collectionView: UICollectionView, sizeForSectionHeaderViewForSection section: Int) -> CGSize {
        
        if posts.count == 0 {
            return CGSize.zero
        } else {
            return CGSize(width: view.frame.width, height: 90)
        }
    }
    
}
