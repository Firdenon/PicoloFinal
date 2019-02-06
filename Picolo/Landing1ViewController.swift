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
        tl.font = UIFont(name: "Avenir-medium",size: 28)
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
        
        titleLabel.setAnchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -180).isActive = true
        
        image.setAnchor(top: titleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 205,height: 178)
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        textView.setAnchor(top: image.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: 0,height: 170)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
