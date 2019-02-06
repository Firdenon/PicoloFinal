//
//  CommentsController.swift
//  Picolo
//
//  Created by Ricky Adi Kuncoro on 24/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var post: Post?
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = "Comments"
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        collectionView.register(CommentsCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchComments()
    }
    
    var comments = [Comment]()
    
    func fetchComments() {
        
        guard let postId = self.post?.id else {return}
        
        let ref = Database.database().reference().child("comments").child(postId)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            
            guard let uid = dictionary["uid"] as? String else {return}
            
            Database.fetchUserWithUid(uid: uid, completion: { (user) in
                
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView.reloadData()
                
            })
        }) { (err) in
            print("Failed to observe Comments")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentsCell
        cell.comment = self.comments[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentsCell(frame: frame)
        
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    lazy var containerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        cv.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
        
        cv.addSubview(submitButton)
        submitButton.setAnchor(top: cv.topAnchor, left: nil, bottom: cv.safeAreaLayoutGuide.bottomAnchor, right: cv.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)

        cv.addSubview(commenTextfield)
        commenTextfield.setAnchor(top: cv.topAnchor, left: cv.leftAnchor, bottom: cv.safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        cv.addSubview(separatorView)
        separatorView.setAnchor(top: cv.topAnchor, left: cv.leftAnchor, bottom: nil, right: cv.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0,height: 0.5)

        return cv
    }()
    
    let submitButton: UIButton = {
        let sb = UIButton(type: .system)
        sb.setTitle("Send", for: .normal)
        sb.setTitleColor(UIColor.lightGray, for: .normal)
        sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sb.isEnabled = false
        sb.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return sb
    }()
    
    let commenTextfield: UITextField = {
        let tx = UITextField()
        tx.placeholder = "Enter Comment"
        tx.addTarget(self, action: #selector(textfieldIsEditing), for: .editingChanged)
        return tx
    }()
    
    @objc func handleSubmit() {
        if Auth.auth().currentUser == nil {
            let loginView = LoginController()
            let navLogin = UINavigationController(rootViewController: loginView)
            present(navLogin, animated: true, completion: nil)
            return
        }
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let postId = self.post?.id ?? ""
        let values = ["text":commenTextfield.text ?? "", "creationDate":Date().timeIntervalSince1970, "uid":uid] as [String:Any]
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to insert comment: \(err.localizedDescription)")
                self.view.endEditing(true)
                return
            }
            print("Succesfully inserted comment")
            self.commenTextfield.text = ""
            self.commenTextfield.resignFirstResponder()
        }
        
    }
    
    @objc func textfieldIsEditing() {
        let isTrue = commenTextfield.text?.count ?? 0 > 0
        if isTrue {
            submitButton.isEnabled = true
            submitButton.setTitleColor(UIColor.rgb(red: 255, green: 150, blue: 123), for: .normal)
        } else {
            submitButton.isEnabled = false
            submitButton.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
    
    override var inputAccessoryView: UIView? {
        return containerView
    }
    
}
