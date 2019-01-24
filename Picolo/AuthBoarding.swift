//
//  AuthBoarding.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 23/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit

class AuthBoarding: UIViewController {
    
    
    let loginButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Login", for: .normal)
        bt.backgroundColor = UIColor.rgb(red: 255, green: 150, blue: 123)
        bt.layer.cornerRadius = 5
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        bt.setTitleColor(.white, for: .normal)
        bt.isEnabled = true
        bt.addTarget(self, action: #selector(handleChange), for: .touchUpInside)
        return bt
    }()
    
    @objc func handleChange() {
        
        let loginView = LoginController()
        let navLogin = UINavigationController(rootViewController: loginView)
        
        present(navLogin, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        
        view.addSubview(loginButton)
        loginButton.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 100)
        
        super.viewDidLoad()
    }
}
