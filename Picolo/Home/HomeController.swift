//
//  HomeController.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 08/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import PinterestLayout

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var posts = [Post](){
        didSet{
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let name = SharePhotoController.updateFeedNotificationName
        self.title = "PICCOLO"
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: name, object: nil)
        
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refresControl = UIRefreshControl()
        refresControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresControl
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            if UIDevice.current.userInterfaceIdiom == .pad {
                layout.numberOfColumns = 3
                layout.delegate = self
                layout.cellPadding = 5
            } else {
                layout.numberOfColumns = 2
                layout.delegate = self
                layout.cellPadding = 5
            }
        }
        setupNavItems()
        fetchAllPost()
    }
    
    @objc func handleUpdateFeed(){
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        print("Handle Refresh.....")
        posts.removeAll()
        fetchAllPost()
    }
    
    fileprivate func setupNavItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(toSearchView))
    }
    
    @objc func toSearchView() {
        let searchController = SearchController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    fileprivate func fetchAllPost() {
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
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
                
                if Auth.auth().currentUser?.uid != nil {
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
                } else {
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                }
            })
        }) { (err) in
            self.collectionView.refreshControl?.endRefreshing()
            print("Failed to fetch post: \(err.localizedDescription)")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
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

extension HomeController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let imageHeight = posts[indexPath.item].imageHeight
        let imageWidth = posts[indexPath.item].imageWidth
        let screenWidth = UIScreen.main.bounds.width
        var lebaryangditentukan: CGFloat = 0
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            lebaryangditentukan = (screenWidth / 3) - 10
        } else {
            lebaryangditentukan = (screenWidth / 2) - 10
        }
        
        let x = imageWidth / lebaryangditentukan
        let panjang = imageHeight / x
        return panjang
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return 0
    }
    
}
