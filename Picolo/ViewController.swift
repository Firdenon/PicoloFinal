//
//  ViewController.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 07/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let photoButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = .lightGray
        return bt
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(photoButton)
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoButton.setAnchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
    }

}

