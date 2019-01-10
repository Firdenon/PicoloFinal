//
//  Firebase Utils.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 08/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUserWithUid(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String:Any] else {return}
            
            let user = User(uid: uid, dictionary: userDictionary)
            
            //self.fetchPostWithUser(user: user)
            print(user.username)
            
            completion(user)
            
        }) { (err) in
            print("Failed to fetch User for post: \(err)")
        }
    }
}
