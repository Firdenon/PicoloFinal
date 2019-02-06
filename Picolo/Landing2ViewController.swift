//
//  Landing2ViewController.swift
//  Picolo
//
//  Created by Kristopher Chayadi on 31/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit

class Landing2ViewController: UIViewController {
    
    let image : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Landing2")
        return iv
    }()
    let textLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name:"Avenir-medium",size: 16)
        lb.text = "Explore, sharing, and connected..."
        lb.textColor = UIColor.orange
        return lb
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
        tv.text = "Three main values of PicColo that giving upon to you as creator or enthusiast. So you can have the most suitable environment."
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        view.addSubview(image)
        view.addSubview(textLabel)
        view.addSubview(textView)
        
        image.setAnchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 227, height: 188)
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100 ).isActive = true
        
        textLabel.setAnchor(top: image.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        textView.setAnchor(top: textLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
