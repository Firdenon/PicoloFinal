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
       let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        btn.setImage(#imageLiteral(resourceName: "Group 2"), for: .normal)
        btn.contentMode = .scaleAspectFill
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
        
        image.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 144, paddingLeft: 92, paddingBottom: 434, paddingRight: 92)
        textView.setAnchor(top: image.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 68, paddingLeft: 50, paddingBottom: 0, paddingRight: 50)
        textLabel.setAnchor(top: textView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 0, paddingRight: 50)
        continueButton.setAnchor(top: textLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 104, paddingLeft: 20, paddingBottom: 125, paddingRight: 20)
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
