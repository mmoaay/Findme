//
//  StoreSceneViewController.swift
//  Findme
//
//  Created by zhengperry on 2017/9/24.
//  Copyright © 2017年 mmoaay. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SVProgressHUD
import SwiftLocation

import CoreML
import Vision

extension StoreSceneViewController: SwitchViewDelegate {
    func switched(status: OperationStatus) {
        self.status = status
        switch status {
        case .locating:
            captureObject.capturePhoto(completion: { (image: Data) in
                self.route.image = image
                
                self.captureObject.stopRunning()
                self.previewView.isHidden = true
                
                Locator.subscribePosition(accuracy: .room, onUpdate: { (loc) -> (Void) in
                    print("New location received: \(loc)")
                }, onFail: { (err, loc) -> (Void) in
                    print("Failed with error: \(err)")
                })
                
                // Create a session configuration
                let configuration = ARWorldTrackingConfiguration()
                configuration.worldAlignment = .gravityAndHeading
                // Run the view's session
                self.sceneView.session.run(configuration)
            })
            break
        case .done:
            if let last = self.last {
                let box = SCNBox(width: Constant.ROUTE_DOT_RADIUS*5, height: Constant.ROUTE_DOT_RADIUS*5, length: Constant.ROUTE_DOT_RADIUS*5, chamferRadius: 0)
                let node = SCNNode(geometry: box)
                node.position = last
                node.geometry?.firstMaterial?.diffuse.contents = UIColor(hexColor: "CD4F39")
                sceneView.scene.rootNode.addChildNode(node)
                
                self.last = nil
            }
            
            self.nameView.isHidden = false
            self.nameTextField.becomeFirstResponder()
            break
        case .save:
            if let name = nameTextField.text {
                if false == name.isEmpty {
                    route.name = name
                    route.scene = self.sceneView.scene
                    if true == RouteCacheService.shared.addRoute(route: route) {
                        self.navigationController?.popViewController(animated: true)
                        
                        self.nameView.isHidden = true
                        self.nameTextField.resignFirstResponder()
                    } else {
                        SVProgressHUD.showError(withStatus: "Save failed, try again")
                        return
                    }
                } else {
                    SVProgressHUD.showError(withStatus: "Please input the name of the suprise")
                    return
                }
            } else {
                SVProgressHUD.showError(withStatus: "Please input the name of the suprise")
                return
            }
            break
        default:
            break
        }
        self.switchView.status = status.next(type: self.switchView.type)
    }
}

class StoreSceneViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var switchView: SwitchView!
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    
    let route = Route()
    
    var status:OperationStatus = .locating
    
    var last: SCNVector3? = nil
    
    var captureObject:CaptureObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        sceneView.autoenablesDefaultLighting = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        switchView.type = .store
        switchView.delegate = self
        
        captureObject = CaptureObject(previewView: previewView, target: self)
        captureObject.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        if .going == status {
            guard let pointOfView = sceneView.pointOfView else { return }
            
            let current = pointOfView.position
            if let last = self.last {
                let distance = last.distance(vector: current)
                if distance < Constant.ROUTE_DOT_INTERVAL { return }
                
//                let cone = SCNCone(topRadius: 0.0, bottomRadius: Constant.ROUTE_DOT_RADIUS, height: Constant.ROUTE_DOT_RADIUS*4.0)
                
                let sphere = SCNSphere(radius: Constant.ROUTE_DOT_RADIUS)
                let node = SCNNode(geometry: sphere)
//                node.runAction(SCNAction.rotateBy(x: CGFloat(Float.pi/2.0), y:CGFloat(asin((current.y-last.y)/distance)), z: CGFloat(asin((current.z-last.z)/distance)), duration: 0.0))
                node.position = current
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                sceneView.scene.rootNode.addChildNode(node)
            } else {
                let box = SCNBox(width: Constant.ROUTE_DOT_RADIUS*5, height: Constant.ROUTE_DOT_RADIUS*5, length: Constant.ROUTE_DOT_RADIUS*5, chamferRadius: 0)
                let node = SCNNode(geometry: box)
                node.position = current
                node.geometry?.firstMaterial?.diffuse.contents = UIColor(hexColor: "43CD80")
                sceneView.scene.rootNode.addChildNode(node)
            }
            
            self.last = current
            
            glLineWidth(0)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
