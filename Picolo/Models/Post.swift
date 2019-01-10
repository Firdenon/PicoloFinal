//
//  Post.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 08/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import Foundation
import UIKit

struct Post {
    let imageHeight: CGFloat
    let imageUrl: String
    let user: User
    let title: String
    
    init(user:User, dictionary: [String:Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.title = dictionary["caption"] as? String ?? ""
        self.imageHeight = dictionary["imgHeight"] as? CGFloat ?? 0
    }
}
