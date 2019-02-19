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
        tl.text = "Detecting Plane"
        tl.font = UIFont(name: "Avenir-medium", size: 18)
        tl.textAlignment = .center
        tl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        tl.textColor = UIColor.black
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
        uiv.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return uiv
    }()
    
    let landingAR2: UIView = {
        let uiv = UIView()
        uiv.isHidden = true
        uiv.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        return uiv
    }()
    
    let toAR2Btn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Continue", for: .normal)
        btn.addTarget(self, action: #selector(toAR2), for: .touchUpInside)
        return btn
    }()
    let toAR1Btn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Back", for: .normal)
        btn.addTarget(self, action: #selector(toAR1), for: .touchUpInside)
        return btn
    }()
    let closeLandingAR: UIButton = {
        let btn = UIButton()
        btn.setTitle("Let's Go", for: .normal)
        btn.addTarget(self, action: #selector(closeLanding), for: .touchUpInside)
        return btn
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
        view.addSubview(landingAR1)
        view.addSubview(landingAR2)
        landingAR1.addSubview(toAR2Btn)
        landingAR2.addSubview(toAR1Btn)
        landingAR2.addSubview(closeLandingAR)
        
        sceneView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        instructionLabel.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 120, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        instructionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        backButton.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 57, paddingLeft: 20, paddingBottom: 0, paddingRight: 0)
        resetButton.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 57, paddingLeft: 0, paddingBottom: 0, paddingRight: 20)
        
        AVCaptureDevice.requestAccess(for: .video) { (res) in
            if res {
                if !UserDefaults.standard.bool(forKey: "hasRunARBefore"){
                    self.landingAR1.isHidden = false
                }
                else {
                    self.instructionLabel.text = "Detecting Plane"
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
                instructionLabel.text = "Yey! Now try to relocate The Image"
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
            
            self.instructionLabel.text = "Detecting Plane"
        }
        flagplane = false
        flagplace = false
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
        UserDefaults.standard.set("true", forKey: "hasRunARBefore")
    }
}
