//
//  Landing1ViewController.swift
//  Picolo
//
//  Created by Kristopher Chayadi on 31/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit

class Landing1ViewController: UIViewController {
    
    let titleLabel : UILabel = {
        let tl = UILabel()
        tl.text = "What is PicColo ?"
        tl.font = UIFont(name: "Avenir-medium",size: 18)
        tl.textAlignment = .center
        tl.textColor = UIColor.orange
        return tl
    }()
    
    let image : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Landing1")
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .center
        tv.textColor = UIColor.orange
        tv.font = UIFont(name:"Avenir-medium",size:18)
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.isSelectable = false
        tv.text = "PicColo is a showcase application where you can show and introduce your doujinshi’s artworks or Admiring the artworks and giving you a new opportunity to being enganged with other creators and enthusiasts."
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        view.addSubview(titleLabel)
        view.addSubview(image)
        view.addSubview(textView)
        
        titleLabel.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 145, paddingLeft: 78, paddingBottom: 0, paddingRight: 78)
        image.setAnchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 34, paddingLeft: 78, paddingBottom: 417, paddingRight: 78)
        textView.setAnchor(top: image.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 63, paddingLeft: 59, paddingBottom: 125, paddingRight: 59)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
