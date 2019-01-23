//
//  CustomImageView.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 08/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import Foundation
import UIKit

var imageChace = [String : UIImage]()

class CustomImageView: UIImageView {
    var lastUrlUsedToLoadImage: String?
    func loadImage(urlString: String) {
        lastUrlUsedToLoadImage = urlString
        self.image = nil
        if let chacedImage = imageChace[urlString] {
            self.image = chacedImage
            return
        }
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image: \(err.localizedDescription)")
            }
            if url.absoluteString != self.lastUrlUsedToLoadImage {
                return
            }
            guard let imgData = data else {return}
            let photoImage = UIImage(data: imgData)
            imageChace[url.absoluteString] = photoImage
            DispatchQueue.main.async {
                self.image = photoImage
            }
            }.resume()
    }
}
