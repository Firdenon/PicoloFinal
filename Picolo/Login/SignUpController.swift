//
//  ViewController.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 07/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageEdited = false
    
    let photoButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = .clear
        bt.setImage(#imageLiteral(resourceName: "Blank Profile Picture"), for: .normal)
        bt.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return bt
    }()
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            photoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        photoButton.layer.cornerRadius = photoButton.frame.width / 2
        photoButton.layer.masksToBounds = true
        photoButton.layer.borderColor = UIColor.black.cgColor
        photoButton.layer.borderWidth = 3
        imageEdited = true
        handleTextInputChange()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageEdited = false
        handleTextInputChange()
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let userNameTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.keyboardType = .alphabet
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
        tf.keyboardType = .alphabet
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextfield.text?.count ?? 0 > 0 && userNameTextfield.text?.count ?? 0 > 0 &&
            passwordTextfield.text?.count ?? 0 > 0
        
        if isFormValid && imageEdited {
            signUpButton.backgroundColor = UIColor.rgb(red: 255, green: 150, blue: 123)
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = .lightGray
            signUpButton.isEnabled = false
        }
    }
    
    let warningLabel: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textColor = UIColor.rgb(red: 255, green: 0, blue: 0)
        lb.textAlignment = .center
        return lb
    }()
    
    let signUpButton: LoadingButton = {
        let bt = LoadingButton(type: .system)
        bt.setTitle("Sign Up", for: .normal)
        bt.backgroundColor = .lightGray
        bt.layer.cornerRadius = 5
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        bt.setTitleColor(.white, for: .normal)
        bt.isEnabled = false
        bt.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return bt
    }()
    
    @objc func handleSignUp() {
        guard let email = emailTextfield.text, email.characters.count > 0 else {return}
        guard let userName = userNameTextfield.text, userName.characters.count > 0 else {return}
        guard let password = passwordTextfield.text, password.characters.count > 0 else {return}
        
        signUpButton.isEnabled = false
        signUpButton.showLoading()
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("failed to create user: \(error)")
                self.signUpButton.hideLoading()
                self.warningLabel.text = "\(error.localizedDescription)"
                return
            }
            print("succesfully created user:\(user?.user.uid)")
            guard let image = self.photoButton.imageView?.image else {return}
            guard let uploaData = image.jpegData(compressionQuality: 0.3) else {return}
            let fileName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child(fileName)
            storageRef.putData(uploaData, metadata: nil, completion: { (metadata, err) in
                if let err = err {
                    print("Failed to upload Profile: \(err.localizedDescription)")
                    self.signUpButton.hideLoading()
                    self.warningLabel.text = "\(err.localizedDescription)"
                    return
                }
                storageRef.downloadURL(completion: { (downloadUrl, err) in
                    if let err = err {
                        print("Failed to fetch downloadUrl: \(err.localizedDescription)")
                        self.signUpButton.hideLoading()
                        self.warningLabel.text = "\(err.localizedDescription)"
                        return
                    }
                    guard let profileImageUrl = downloadUrl?.absoluteString else {return}
                    print("Succes upload profile picture: \(profileImageUrl)")
                    guard let uid = user?.user.uid else {return}
                    let dictionaryValues = ["username":userName, "profileImageUrl":profileImageUrl]
                    let value = [uid:dictionaryValues]
                    Database.database().reference().child("users").updateChildValues(value, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print("Failed to save user info into db: \(err)")
                            self.signUpButton.hideLoading()
                            self.warningLabel.text = "\(err.localizedDescription)"
                            return
                        } else {
                            let followDictionary = ["followersCount" : 0, "followingsCount" : 0]
                            let followValue = [uid:followDictionary]
                            Database.database().reference().child("followCount").updateChildValues(followValue, withCompletionBlock: { (err, ref) in
                                if let err = err {
                                    print("Failed to init followCount: \(err.localizedDescription)")
                                    self.signUpButton.hideLoading()
                                    self.warningLabel.text = "\(err.localizedDescription)"
                                    return
                                } else {
                                    print("Succesfuly save user info into db")
                                    guard let maintabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
                                    maintabBarController.setupViewControllers()
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                        }
                    })
                })
            })
        }
    }
    
    let alreadyHaveAccountButton: UIButton = {
        let bt = UIButton(type: .system)
        let attributed = NSMutableAttributedString(string: "Already have an account ? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        attributed.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 255, green: 150, blue: 123)]))
        bt.setAttributedTitle(attributed, for: .normal)
        bt.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return bt
    }()
    
    @objc func handleAlreadyHaveAccount() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        view.addSubview(photoButton)
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoButton.setAnchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        setupInputField()
    }
    
    fileprivate func setupInputField() {
        let stackView = UIStackView(arrangedSubviews: [userNameTextfield, emailTextfield, passwordTextfield, warningLabel, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.setAnchor(top: photoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 300)
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.setAnchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor , right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
}

