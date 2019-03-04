//
//  HomePostDetailARSCN.swift
//  Picolo
//
//  Created by Kristopher Chayadi on 11/01/19.
//  Copyright © 2019 Ricky Adi Kuncoro. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import SceneKit

class HomePostDetailARSCN: UIViewController,ARSCNViewDelegate{
    
    var post: Post?{
        didSet{
            guard let imageURL = post?.imageUrl else {return}
            print(imageURL)
            let imageWidth = post?.imageWidth
            print(imageWidth)
            let imageHeight = post?.imageHeight
            print(imageHeight)
            imagePost.loadImage(urlString: imageURL){
                
            }
            image = imagePost.image
        }
    }
    
    let sceneView: ARSCNView = {
        let sc = ARSCNView()
        return sc
    }()
    
    var instructionLabel:UILabel = {
        let tl = UILabel()
        tl.font = UIFont(name: "Avenir-medium", size: 18)
        tl.textAlignment = .center
        tl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        tl.textColor = UIColor.black
        tl.numberOfLines = 2
        return tl
    }()
    
    let resetButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        btn.setImage(#imageLiteral(resourceName: "Group 3"), for: .normal)
        btn.addTarget(self, action: #selector(reset), for: .touchUpInside)
        return btn
    }()
    
    let backButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        btn.setImage(#imageLiteral(resourceName: "backbuttonAR"), for: .normal)
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        return btn
    }()
    
    let landingAR1: UIView = {
        let uiv = UIView()
        uiv.isHidden = true
        uiv.backgroundColor = .white
        return uiv
    }()
    
    let landingAR2: UIView = {
        let uiv = UIView()
        uiv.isHidden = true
        uiv.backgroundColor = .white
        return uiv
    }()
    
    let imageLanding1: UIImageView = {
        let uiv = UIImageView()
        uiv.image = UIImage(named: "LandingAR1")
        uiv.contentMode = .scaleAspectFit
        return uiv
    }()
    
    let imageLanding2: UIImageView = {
        let uiv = UIImageView()
        uiv.image = UIImage(named: "LandingAR2")
        uiv.contentMode = .scaleAspectFit
        return uiv
    }()
    
    lazy var toAR2Btn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "ContinueButtonAR"), for: .normal)
        btn.addTarget(self, action: #selector(toAR2), for: .touchUpInside)
        return btn
    }()
    lazy var toAR1Btn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "Back"), for: .normal)
        btn.addTarget(self, action: #selector(toAR1), for: .touchUpInside)
        return btn
    }()
    lazy var closeLandingAR: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "letsgoAR"), for: .normal)
        btn.addTarget(self, action: #selector(closeLanding), for: .touchUpInside)
        return btn
    }()
    
    lazy var ssButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "kameraAR").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(screenshot), for: .touchUpInside)
        return btn
    }()
    
    let textView1: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .center
        tv.textColor = UIColor.orange
        tv.font = UIFont(name:"Avenir-medium",size:18)
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.isSelectable = false
        tv.text = "Make sure you are standing with maximum distance 1,5 meter from the wall"
        
        return tv
    }()
    
    let textView2: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .center
        tv.textColor = UIColor.orange
        tv.font = UIFont(name:"Avenir-medium",size:18)
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.isSelectable = false
        tv.text = "Find the wall and make sure your device in portrait mode. \nDon't use white wall, it is hard to detect"
        
        return tv
    }()
    
    
    var imagePost = CustomImageView()
    var image : UIImage?
    
    var flag = true
    var flagplane:Bool = false
    var flagplace:Bool = false
    
    let nodeGambar = SCNNode()
    let nodePlane = SCNNode()
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        sceneView.delegate = self
        view.addSubview(sceneView)
        view.addSubview(instructionLabel)
        view.addSubview(backButton)
        view.addSubview(resetButton)
        view.addSubview(ssButton)
        
        var landingWidth = view.frame.width
        var landingHeight = (view.frame.height / 2) + 20
        
        view.addSubview(landingAR1)
        landingAR1.addSubview(toAR2Btn)
        landingAR1.addSubview(imageLanding1)
        landingAR1.addSubview(textView1)
        
        view.addSubview(landingAR2)
        landingAR2.addSubview(toAR1Btn)
        landingAR2.addSubview(imageLanding2)
        landingAR2.addSubview(closeLandingAR)
        landingAR2.addSubview(textView2)
        
        sceneView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        instructionLabel.setAnchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 120, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        instructionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        backButton.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 57, paddingLeft: 20, paddingBottom: 0, paddingRight: 0)
        resetButton.setAnchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 57, paddingLeft: 0, paddingBottom: 0, paddingRight: 20)
        ssButton.setAnchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0)
        ssButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        landingAR1.setAnchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: landingWidth, height: landingHeight)
        landingAR1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        landingAR1.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        toAR2Btn.setAnchor(top: nil, left: nil, bottom: landingAR1.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0)
        toAR2Btn.centerXAnchor.constraint(equalTo: landingAR1.centerXAnchor).isActive = true
//        toAR2Btn.centerYAnchor.constraint(equalTo: landingAR1.centerYAnchor).isActive = true
        
        imageLanding1.setAnchor(top: landingAR1.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: 200,height: 200)
        imageLanding1.centerXAnchor.constraint(equalTo: landingAR1.centerXAnchor).isActive = true
        
        textView1.setAnchor(top: imageLanding1.bottomAnchor, left: landingAR1.leftAnchor, bottom: toAR2Btn.topAnchor, right: landingAR1.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        textView1.centerXAnchor.constraint(equalTo: landingAR1.centerXAnchor).isActive = true
        
        landingAR2.setAnchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: landingWidth, height: landingHeight)
        landingAR2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        landingAR2.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        imageLanding2.setAnchor(top: landingAR2.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,width: 200, height: 200)
        imageLanding2.centerXAnchor.constraint(equalTo: landingAR2.centerXAnchor).isActive = true
        
        toAR1Btn.setAnchor(top: landingAR2.topAnchor, left: landingAR2.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        
        textView2.setAnchor(top: imageLanding2.bottomAnchor, left: landingAR2.leftAnchor, bottom: nil, right: landingAR2.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        textView2.centerXAnchor.constraint(equalTo: landingAR1.centerXAnchor).isActive = true
        
        closeLandingAR.setAnchor(top: nil, left: nil, bottom: landingAR2.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0)
        closeLandingAR.centerXAnchor.constraint(equalTo: landingAR2.centerXAnchor).isActive = true

        
        
        AVCaptureDevice.requestAccess(for: .video) { (res) in
            if res {
                if !UserDefaults.standard.bool(forKey: "hasRunARBefore"){
                    DispatchQueue.main.async {
                        self.landingAR1.isHidden = false
                        self.toAR2Btn.isHidden = false
                        self.backButton.isHidden = true
                        self.resetButton.isHidden = true
                        self.instructionLabel.isHidden = false
                        self.ssButton.isHidden = true
                        print(self.landingAR1.isHidden)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.instructionLabel.text = "Detecting Vertical Plane"
                    }
                    self.flagplane = false
                    self.flagplace = false
                    self.sceneView.autoenablesDefaultLighting = true
                }
            } else {
                let alertController = UIAlertController (title: "Camera Authorization", message: "Please authorized our apps to acces your camera", preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {return}
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (success) in
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        
        if ARWorldTrackingConfiguration.isSupported{
            configuration.planeDetection = [.vertical]
            sceneView.session.run(configuration)
        }
        else {
            print("device ga support")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor && flagplane == false {
            
            DispatchQueue.main.async {
                self.instructionLabel.text = "Plane Detected, Tap to Place Image"
            }
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            nodePlane.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            nodePlane.eulerAngles.x = -.pi/2
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            nodePlane.geometry = plane
            
            node.addChildNode(nodePlane)
            flagplane = true
            print("planeAnchor X : \(planeAnchor.extent.x)")
            print("planeAnchor z : \(planeAnchor.extent.z)")
        }
        else{
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if flagplace == false && flagplane == true {
            if let touch = touches.first{
                instructionLabel.text = "Yey! Now try to drag The Image \nand Enjoy placing"
                let touchLocation = touch.location(in: sceneView)
                
                let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
                
                if let hitResult = results.first{
                    
    //                let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
    //                let material = SCNMaterial()
    //                material.diffuse.contents = UIColor.red
    //                cube.materials = [material]
                    
                    let imagePlane = SCNPlane(width: 0.5, height: 0.5)
                    
                    let width = Float(imagePlane.width)
                    let height = Float(imagePlane.height)
    //                let imageMaterial = SCNMaterial()
    //                imageMaterial.diffuse.contents = imagePost
    //                imagePlane.materials = [imageMaterial]
                    
                    nodeGambar.position = SCNVector3(
                        x: hitResult.worldTransform.columns.3.x,
                        y: hitResult.worldTransform.columns.3.y,
                        z: hitResult.worldTransform.columns.3.z)
                    //node.eulerAngles.x = -.pi/2
                    
                    let gridMaterial = SCNMaterial()
                    gridMaterial.diffuse.contents = image
//                    gridMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(width, height, 0)
                    gridMaterial.diffuse.wrapS = .repeat
                    gridMaterial.diffuse.wrapT = .repeat
                    imagePlane.materials = [gridMaterial]
                    
    //                node.geometry = cube
                    
                    nodeGambar.geometry = imagePlane
                    sceneView.scene.rootNode.addChildNode(nodeGambar)
                    nodePlane.geometry = nil
                    flagplace = true
                }
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if flagplace == true {
            //get the current touch point
            guard let currentTouchPoint = touches.first?.location(in: self.sceneView),
                
            //get the next feature point Etc
            let hitTest = sceneView.hitTest(currentTouchPoint,types: .existingPlane).first else {return}
            
            //convert to world coordinates
            let worldTransform = hitTest.worldTransform
            
            //set the new position
            let newPosition = SCNVector3(worldTransform.columns.3.x,
                                         worldTransform.columns.3.y,
                                         worldTransform.columns.3.z)
            
            //apply to the node
            nodeGambar.position = newPosition
            
        }
    }
    
    @objc func reset(){
//        self.sceneView.scene.rootNode.enumerateChildNodes{(existingNode,_) in existingNode.removeFromParentNode()}
//        viewDidLoad()
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        DispatchQueue.main.async {
            
            self.instructionLabel.text = "Detecting Vertical Plane"
        }
        flagplane = false
        flagplace = false
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @objc func back(){
        print("back kepencet")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func toAR1(){
        landingAR2.isHidden = true
        landingAR1.isHidden = false
    }
    @objc func toAR2(){
        landingAR1.isHidden = true
        landingAR2.isHidden = false
    }
    @objc func closeLanding(){
        landingAR1.isHidden = true
        landingAR2.isHidden = true
        backButton.isHidden = false
        resetButton.isHidden = false
        instructionLabel.isHidden = false
        ssButton.isHidden = false
        instructionLabel.text = "Detecting Vertical Plane"
        UserDefaults.standard.set("true", forKey: "hasRunARBefore")
    }
    
    @objc func screenshot(){
        
//        DispatchQueue.main.async {
//            self.ssWatermark.isHidden = false
//            self.backButton.isHidden = true
//            self.resetButton.isHidden = true
//            self.instructionLabel.isHidden = true
//            self.ssButton.isHidden = true
//        }
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
//        view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = sceneView.snapshot()
//        UIGraphicsEndImageContext()
//
//        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
//
//        DispatchQueue.main.async {
//            self.ssWatermark.isHidden = true
//            self.backButton.isHidden = false
//            self.resetButton.isHidden = false
//            self.instructionLabel.isHidden = false
//            self.ssButton.isHidden = false
        
//        }
        let image = sceneView.snapshot()
        let previewScreenshot = PreviewScreenshot()
        previewScreenshot.image = image
        navigationController?.pushViewController(previewScreenshot, animated: true)
//        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
//
//        activityController.completionWithItemsHandler = { (nil, completed, _, error) in
//            if completed {
//                print("completed")
//            } else {
//                print("cancled")
//            }
//        }
//        present(activityController, animated: true) {
//            print("presented")
//        }
//    }
    }
    
}

class PreviewScreenshot: UIViewController {
    
    var image: UIImage? {
        didSet{
            previewImage.image = image
        }
    }
    
    let previewImage: UIImageView = {
        let uiv = UIImageView()
        return uiv
    }()
    
    let ssWatermark: UIImageView = {
        let uiv = UIImageView()
        uiv.image = UIImage(named: "ssWatermark")
        uiv.contentMode = .scaleAspectFit
        return uiv
    }()
    
    let backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "backbuttonAR"), for: .normal)
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        return btn
    }()
    let saveButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "downloadAR"), for: .normal)
        btn.addTarget(self, action: #selector(save), for: .touchUpInside)
        return btn
    }()
    let shareButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "shareAR"), for: .normal)
        btn.addTarget(self, action: #selector(share), for: .touchUpInside)
        return btn
    }()
    var imageSS = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(previewImage)
        view.addSubview(ssWatermark)
        previewImage.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        ssWatermark.setAnchor(top: nil, left: nil, bottom: previewImage.bottomAnchor, right: previewImage.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 10,width: 100,height: 50)
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        imageSS = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        
        view.addSubview(backButton)
        view.addSubview(saveButton)
        view.addSubview(shareButton)
        backButton.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 57, paddingLeft: 20, paddingBottom: 0, paddingRight: 0)
        shareButton.setAnchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 57, paddingLeft: 0, paddingBottom: 0, paddingRight: 20)
        saveButton.setAnchor(top: view.topAnchor, left: nil, bottom: nil, right: shareButton.leftAnchor, paddingTop: 57, paddingLeft: 0, paddingBottom: 0, paddingRight: 20)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc func back(){
        navigationController?.popViewController(animated: true)
    }
    @objc func share(){
        print("share")
        let activityController = UIActivityViewController(activityItems: [imageSS], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { (nil, completed, _, error) in
            if completed {
                print("completed")
            } else {
                print("cancled")
            }
        }
        self.present(activityController, animated: true, completion: nil)
    }
    @objc func save(){
        print("save")
        UIImageWriteToSavedPhotosAlbum(imageSS, nil, nil, nil)
        let alertController = UIAlertController(title:"Screenshot Saved!",message:nil,preferredStyle:.alert)
        self.present(alertController,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: 0.5, repeats:false, block: {_ in
            self.dismiss(animated: true, completion: nil)})})
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}
