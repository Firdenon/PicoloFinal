//
//  UserProfileViewController.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 07/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import PinterestLayout

class UserProfileViewController: UICollectionViewController{
    
    let cellId = "cellId"
    var userId: String?
    var posts = [Post]() {
        didSet {
            print("hello___")
            DispatchQueue.main.async {
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "first")
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
            layout.cellPadding = 10
            layout.numberOfColumns = 2
        }
        
        fetchUser()
        setupNavBar()
        //fetchOrderedPost()
    }
    
    fileprivate func setupNavBar() {
        guard let currentLoginId = Auth.auth().currentUser?.uid else {return}
        if currentLoginId == userId || userId == nil {
            //edit
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleLogout))
            self.navigationItem.title = "My Profile"
        } else {
            
            guard let userUid = userId else {return}
            Database.database().reference().child("following").child(currentLoginId).child(userUid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    let rightbutton = UIBarButtonItem(title: "Unfollow", style: .plain, target: self, action: #selector(self.handleFollow))
                    rightbutton.tintColor = .lightGray
                    DispatchQueue.main.async {
                        self.navigationItem.rightBarButtonItem = rightbutton
                        self.navigationItem.title = "Followed Profile"
                    }
                } else {
                    let rightbutton = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(self.handleFollow))
                    rightbutton.tintColor = self.view.tintColor
                    DispatchQueue.main.async {
                        self.navigationItem.rightBarButtonItem = rightbutton
                        self.navigationItem.title = "Someone Profile"
                    }
                }
            }) { (err) in
                print("Failed to check")
            }
        }
    }
    
    @objc func handleLogout() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let loginController = MainTabBarController()
                //let navController = UINavigationController(rootViewController: loginController)
                self.present(loginController, animated: true, completion: nil)
            } catch let signOutErr {
                print("Failed to sign out: \(signOutErr)")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func handleFollow() {
        guard let currentId = Auth.auth().currentUser?.uid else {return}
        if navigationItem.rightBarButtonItem?.title == "Unfollow" {
            print("unfollowed")
            //unfollow
            guard let userUid = userId else {return}
            Database.database().reference().child("following").child(currentId).child(userUid).removeValue { (err, ref) in
                if let err = err {
                    print("Failed to unfollow user: \(err.localizedDescription)")
                    return
                }
                print("Succes unfollow user: \(userUid)")
                DispatchQueue.main.async {
                    let rightbutton = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(self.handleFollow))
                    rightbutton.tintColor = self.view.tintColor
                    self.navigationItem.rightBarButtonItem = rightbutton
                    self.navigationItem.title = "Someone Profile"
                }
            }
        } else {
            //follow
            let ref = Database.database().reference().child("following").child(currentId)
            let values = [userId: 1]
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to follow user: \(err.localizedDescription)")
                }
                print("Succesfully followed user: \(self.userId ?? "")")
                DispatchQueue.main.async {
                    let rightbutton = UIBarButtonItem(title: "Unfollow", style: .plain, target: self, action: #selector(self.handleFollow))
                    rightbutton.tintColor = .lightGray
                    self.navigationItem.rightBarButtonItem = rightbutton
                    self.navigationItem.title = "Followed Profile"
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (posts.count + 1)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
        let firstCell = collectionView.dequeueReusableCell(withReuseIdentifier: "first", for: indexPath)
        
        if indexPath.row == 0 {
            firstCell.backgroundColor = .lightGray
            firstCell.layer.shadowColor = UIColor.black.cgColor
            firstCell.layer.shadowOffset = CGSize(width: 0, height: 0.1)
            firstCell.layer.shadowRadius = 2.0
            firstCell.layer.shadowOpacity = 0.5
            firstCell.layer.masksToBounds = false
            firstCell.clipsToBounds = false
            return firstCell
        } else {
            cell.post = posts[indexPath.item - 1]
            //cell.labelTest.text = "\(indexPath.item)"
            cell.backgroundColor = .lightGray
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0.1)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 0.5
            cell.layer.masksToBounds = false
            cell.clipsToBounds = false
            cell.layer.cornerRadius = 20
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil)
        } else {
            let detail = HomePostDetail()
            detail.post = posts[indexPath.item - 1]
            navigationController?.pushViewController(detail, animated: true)
        }
    }
    
    var user: User?
    
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        //guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.fetchUserWithUid(uid: uid) { (user) in
            self.user = user
            DispatchQueue.main.async {
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.reloadData()
            }
            self.fetchOrderedPost()
        }
    }
    
    fileprivate func fetchOrderedPost() {
        guard let uid = self.user?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let user = self.user else {return}
            var post = Post(user: user, dictionary: dictionary)
            post.id = snapshot.key
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            Database.database().reference().child("likes").child(snapshot.key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let value = snapshot.value as? Int, value == 1 {
                    post.hasLiked = true
                } else {
                    post.hasLiked = false
                }
                
                self.posts.insert(post, at: 0)
                DispatchQueue.main.async {
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.reloadData()
                }
            }, withCancel: { (err) in
                print("Failed to fetch like info for post")
            })
            
        }) { (err) in
            print("Failed to fetch ordered post")
        }
    }
}

extension UserProfileViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        
        let panjang: CGFloat
        
        if indexPath.row == 0 {
            return (375 / 2)
        } else {
            let imageHeight = posts[indexPath.item - 1].imageHeight
            let imageWidth = posts[indexPath.item - 1].imageWidth
            let lebaryangditentukan:CGFloat = (375 / 2) - 20
            let x = imageWidth / lebaryangditentukan
            panjang = imageHeight / x
        }
        return panjang
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user
        return header
    }
    
    func collectionView(collectionView: UICollectionView, sizeForSectionHeaderViewForSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 180)
    }
}

