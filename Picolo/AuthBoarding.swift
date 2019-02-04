//
//  AuthBoarding.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 23/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit

class AuthBoarding: UIViewController {
    
    
    let boardImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "rocket").withRenderingMode(.alwaysOriginal)
        return iv
    }()
    
    let boardTitle: UILabel = {
        let lb = UILabel()
        lb.text = "Wanna explore more?" + "\n" + "Please Sign up or Login" + "\n" + "to use full potential of our Apps"
        lb.font = UIFont(name:"Avenir-medium",size:18)
        lb.textColor = UIColor.rgb(red: 255, green: 150, blue: 123)
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()
    
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
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(boardImage)
        boardImage.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 170, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 205, height: 178)
        boardImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(boardTitle)
        boardTitle.setAnchor(top: boardImage.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width:0 , height: 100)
        
        view.addSubview(loginButton)
        loginButton.setAnchor(top: boardTitle.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 45)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
