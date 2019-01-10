//
//  SearchController.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 08/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.barTintColor = .lightGray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        
        fetchUsers()
    }
    
    fileprivate func fetchUsers(){
        print("Fetching Users.......")
        
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value)
        }) { (err) in
            print("Failed to fetch users for search: \(err.localizedDescription)")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
}
