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
            imagePost.loadImage(urlString: (post?.imageUrl)!)
//            photoImageView.loadImage(urlString: imageURL)
//            titleLable.text = post?.title
//            guard let usernameText = post?.user.username else {return}
//            usernameLabel.text = "by " + (usernameText)
//            guard let profileImageUrl = post?.user.profileImageUrl else {return}
//            profileImageView.loadImage(urlString: profileImageUrl)
        }
    }
    
    let sceneView: ARSCNView = {
        let sc = ARSCNView()
        return sc
    }()
    
    
    var imagePost = UIImage()
    
    
    var flag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        sceneView.delegate = self
        view.addSubview(sceneView)
        sceneView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//        let material = SCNMaterial()
//
//        material.diffuse.contents = UIColor.red
//        cube.materials = [material]
//
//        let node = SCNNode()
//        node.position = SCNVector3(x: 0,y: 0.1, z: -0.5)
//        node.geometry = cube
//
//        sceneView.scene.rootNode.addChildNode(node)
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARWorldTrackingConfiguration.isSupported{
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.vertical]
            sceneView.session.run(configuration)
        }
        else {
            print("device ga support")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            planeNode.eulerAngles.x = -.pi/2
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            print("planeAnchor X : \(planeAnchor.extent.x)")
            print("planeAnchor z : \(planeAnchor.extent.z)")
        }
        else{
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first{
                
//                let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//                let material = SCNMaterial()
//                material.diffuse.contents = UIColor.red
//                cube.materials = [material]
                
                let imagePlane = SCNPlane(width: 0.5, height: 0.5)
//                let imageMaterial = SCNMaterial()
//                imageMaterial.diffuse.contents = imagePost
//                imagePlane.materials = [imageMaterial]
                let node = SCNNode()
                node.position = SCNVector3(
                    x: hitResult.worldTransform.columns.3.x,
                    y: hitResult.worldTransform.columns.3.y,
                    z: hitResult.worldTransform.columns.3.z)
                //node.eulerAngles.x = -.pi/2
                
                let gridMaterial = SCNMaterial()
                gridMaterial.diffuse.contents = UIColor.red
                imagePlane.materials = [gridMaterial]
                
//                node.geometry = cube
                
                node.geometry = imagePlane
                sceneView.scene.rootNode.addChildNode(node)
            }
        }
    }
    
    
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        if anchor is ARPlaneAnchor {
//            let planeAnchor = anchor as! ARPlaneAnchor
//            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
//
//            //attach plane anchor to node
//            let planeNode = SCNNode()
//            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
//            planeNode.eulerAngles.x = -.pi/2
//
//            //adding material to plane anchor
//            let gridMaterial = SCNMaterial()
//            gridMaterial.diffuse.contents = UIImage(named: "ARassets.scnassets/grid.png")
//            plane.materials = [gridMaterial]
//            planeNode.geometry = plane
//
//            //add plane node to node as child node
//            node.addChildNode(planeNode)
//
//            let newConf = ARWorldTrackingConfiguration()
//            newConf.planeDetection = [.horizontal, .vertical]
//        } else {
//            //return if doesn't find plane
//            return
//        }
//    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if flag == false { return } else {
//            if let touch = touches.first {
//                let touchLocation = touch.location(in: sceneView)
//                let result = sceneView.hitTest(touchLocation, types: .existingPlaneUsingGeometry)
//                if let hitResult = result.first {
//                    let hasil = arrayOfStand[Int(objectStepper.value)]
//                    hasil.position = SCNVector3(
//                            hitResult.worldTransform.columns.3.x,
//                            hitResult.worldTransform.columns.3.y,
//                            hitResult.worldTransform.columns.3.z)
//
//                        //hasil.eulerAngles.x = -.pi/2
//                        sceneView.scene.rootNode.addChildNode(hasil)
//                        //print(arrayOfImage[Int(objectStepper.value)].nama)
//                }
//            }
//        }
//    }
//
    
}
