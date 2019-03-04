//
//  Landing3ViewController.swift
//  Picolo
//
//  Created by Kristopher Chayadi on 31/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit

class Landing3ViewController: UIViewController {
    
    let image : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Landing3")
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
        tv.text = "You can even experience the artwork virtually through Augmented Reality."
        return tv
    }()
    let textLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name:"Avenir-medium",size: 18)
        lb.text = "Ready to experience it?"
        lb.textAlignment = .center
        lb.textColor = UIColor.orange
        return lb
    }()
    
    let continueButton:UIButton = {
       let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "Group 2").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(continueToMain), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        self.view.addSubview(image)
        self.view.addSubview(textView)
        self.view.addSubview(textLabel)
        self.view.addSubview(continueButton)
        
        image.setAnchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: 191,height: 234)
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        
        textView.setAnchor(top: image.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: 0, height: 100)
        textLabel.setAnchor(top: textView.bottomAnchor, left: view.leftAnchor, bottom: continueButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0)
        continueButton.setAnchor(top: textLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func continueToMain(){
//        GlobalVariable.flagOpen = 1
        UserDefaults.standard.set("true", forKey: "hasRunBefore")
        present(MainTabBarController(), animated: true, completion: nil)
    }
}
