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

class SubscriptionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var posts = [Post](){
        didSet{
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Bner")
        
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
        fetchAllPost()
    }
    
    fileprivate func fetchAllPost() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdDict = snapshot.value as? [String:Any] else {return}
            userIdDict.forEach({ (key, value) in
                Database.fetchUserWithUid(uid: key, completion: { (user) in
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
                self.posts.append(post)
            })
            
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }) { (err) in
            print("Failed to fetch post: \(err.localizedDescription)")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        return header
    }
    
    func collectionView(collectionView: UICollectionView, sizeForSectionHeaderViewForSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 180)
    }
    
}
