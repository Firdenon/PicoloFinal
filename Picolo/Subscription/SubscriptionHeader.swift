//
//  SubscriptionHeader.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 23/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit
import PinterestLayout

protocol SubscriptionHeaderDelegate {
    func allAction()
    func toFollowedUser(user: User)
}

class SubscriptionHeader: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var delegate: SubscriptionHeaderDelegate?
    
    var user = [User]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var button: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("ALL", for: .normal)
        bt.addTarget(self, action: #selector(allAction), for: .touchUpInside)
        return bt
    }()
    
    @objc func allAction() {
        delegate?.allAction()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupView()
    }
    
    fileprivate func setupView() {
        addSubview(collectionView)
        addSubview(button)
        
        collectionView.register(SubscriptionHeaderCell.self, forCellWithReuseIdentifier: "headerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.setAnchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        button.setAnchor(top: safeAreaLayoutGuide.topAnchor, left: collectionView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! SubscriptionHeaderCell
        cell.user = user[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let followUser = user[indexPath.row]
        delegate?.toFollowedUser(user: followUser)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SubscriptionHeaderCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            guard let urlImg = user?.profileImageUrl else {return}
            guard let userLabel = user?.username else {return}
            label.text = userLabel
            imageView.loadImage(urlString: urlImg) {
            }
        }
    }
    
    let imageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let label: UILabel = {
        let lb = UILabel()
        lb.text = "test"
        lb.textAlignment = .center
        lb.font = UIFont(name: "Avenir-medium", size: 12)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupView()
    }
    
    fileprivate func setupView() {
        addSubview(imageView)
        
        imageView.setAnchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 56, height: 56)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        imageView.layer.cornerRadius = 56 / 2
        imageView.clipsToBounds = true
        
        addSubview(label)
        label.setAnchor(top: imageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 3, paddingBottom: 0, paddingRight: 3, width: 0, height: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
