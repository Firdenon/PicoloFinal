//
//  LoginController.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 07/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    let logoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 150, blue: 123)
        return view
    }()
    
    let signUpButton: UIButton = {
        let bt = UIButton(type: .system)
        let attributed = NSMutableAttributedString(string: "Don't have an account ? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        attributed.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 255, green: 150, blue: 123)]))
        bt.setAttributedTitle(attributed, for: .normal)
        bt.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return bt
    }()
    
    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    let emailTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextfield.text?.count ?? 0 > 0 && passwordTextfield.text?.count ?? 0 > 0
        if isFormValid {
            loginButton.backgroundColor = UIColor.rgb(red: 255, green: 200, blue: 120)
            loginButton.isEnabled = true
        } else {
            loginButton.backgroundColor = UIColor.rgb(red: 255, green: 150, blue: 123)
            loginButton.isEnabled = false
        }
    }
    
    let loginButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Login", for: .normal)
        bt.backgroundColor = UIColor.rgb(red: 255, green: 150, blue: 123)
        bt.layer.cornerRadius = 5
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        bt.setTitleColor(.white, for: .normal)
        bt.isEnabled = false
        bt.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return bt
    }()
    
    let cancelButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Cancel", for: .normal)
        bt.backgroundColor = UIColor.rgb(red: 255, green: 150, blue: 123)
        bt.layer.cornerRadius = 5
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        bt.setTitleColor(.white, for: .normal)
        bt.isEnabled = true
        bt.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return bt
    }()
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLogin() {
        guard let email = emailTextfield.text else {return}
        guard let password = passwordTextfield.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print("Failed to Sign in with email: \(err.localizedDescription)")
                return
            }
            print("Succesfully logged back in with user: \(user?.user.uid ?? "")")
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        view.addSubview(logoContainer)
        logoContainer.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 300)
        view.addSubview(signUpButton)
        signUpButton.setAnchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        setupInputField()
    }
    
    fileprivate func setupInputField() {
        let stackView = UIStackView(arrangedSubviews: [emailTextfield,passwordTextfield,loginButton,cancelButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.setAnchor(top: logoContainer.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
    }
}
