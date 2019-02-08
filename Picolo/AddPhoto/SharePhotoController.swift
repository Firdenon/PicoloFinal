//
//  SharePhotoController.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 08/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var selectedImage: UIImage? {
        didSet{
            self.imageView.image = selectedImage
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let textView: UITextField = {
        let tv = UITextField()
        tv.font = UIFont(name: "Avenir-medium", size: 23)
        tv.placeholder = "Your title here"
        return tv
    }()
    
    let descriptionTextView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Avenir-medium", size: 14)
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tv.text = "Description (optional)"
        tv.textColor = .lightGray
        return tv
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return true}
        let count = text.count + string.count - range.length
        return count <= 16
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description (optional)"
            textView.textColor = UIColor.lightGray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        textView.delegate = self
        descriptionTextView.delegate = self
        setupImageAndTextView()
    }
    
    fileprivate func setupImageAndTextView(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        containerView.addSubview(imageView)
        imageView.setAnchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        containerView.addSubview(textView)
        textView.setAnchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 10, paddingRight: 10)
        
        view.addSubview(descriptionTextView)
        descriptionTextView.setAnchor(top: containerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
    }
    
    fileprivate func loadingMask() {
        let alert = UIAlertController(title: nil, message: "Uploading...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func disableLoadingMask() {
        if let vc = self.presentedViewController, vc is UIAlertController {
            dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func handleShare() {
        guard let caption = textView.text, caption.count > 0 else {return}
        guard let description = descriptionTextView.text, descriptionTextView.text != "Description (optional)" else {return}
        guard let image = selectedImage else {return}
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else {return}
        navigationItem.rightBarButtonItem?.isEnabled = false
        let filename = NSUUID().uuidString
        
        loadingMask()
        
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                print("Failed to upload post image: \(err.localizedDescription)")
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.disableLoadingMask()
                return
            }
            storageRef.downloadURL(completion: { (url, err) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to fetch donwload URL: \(err.localizedDescription)")
                    self.disableLoadingMask()
                    return
                }
                guard let imageUrlString = url?.absoluteString else {return}
                print("Success upload post image: \(imageUrlString)")
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrlString)
            })
        }
    }
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "updateFeed")
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else {return}
        guard let caption = textView.text else {return}
        guard let description = descriptionTextView.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        let values = ["imageUrl":imageUrl, "caption":caption, "description":description, "imgWidth":postImage.size.width, "imgHeight":postImage.size.height, "creationDate":Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB: \(err.localizedDescription)")
                return
            }
            guard let postKey = ref.key else {return}
            let likeDictionary = ["likesCount" : 0]
            let likeValue = [postKey:likeDictionary]
            let moreRef = Database.database().reference().child("likeCount")
            moreRef.updateChildValues(likeValue, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to add likeCount: \(err.localizedDescription)")
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    return
                } else {
                    print("Successfully saved post to DB")
                    self.disableLoadingMask()
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
                }
            })
           
        }
    }
}
