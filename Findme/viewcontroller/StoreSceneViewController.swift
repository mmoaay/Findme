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
import CoreLocation

extension StoreSceneViewController: SwitchViewDelegate {
    func switched(status: OperationStatus) {
        self.status = status
        switch status {
        case .locating:
            if let currentFrame = sceneView.session.currentFrame, let image = UIImage(pixelBuffer: currentFrame.capturedImage, context:CIContext()) {
                route.image = image
                sceneView.session.run(configuration, options: .resetTracking)
            } else {
                return
            }
            break
        case .done:
            if let last = self.last {
                NodeUtil.addEndNode(rootNode: self.sceneView.scene.rootNode, position: last)
                self.last = nil
                
                route.scene = sceneView.scene
            }
    
            nameView.isHidden = false
            nameTextField.becomeFirstResponder()
            break
        case .save:
            if let name = nameTextField.text {
                if false == name.isEmpty {
                    route.name = name
                    if true == RouteCacheService.shared.addRoute(route: route) {
                        navigationController?.popViewController(animated: true)
                        
                        nameView.isHidden = true
                        nameTextField.resignFirstResponder()
                    } else {
                        SVProgressHUD.showError(withStatus: "Save failed, try again")
                        return
                    }
                } else {
                    SVProgressHUD.showError(withStatus: "Please input the name of the route")
                    return
                }
            } else {
                SVProgressHUD.showError(withStatus: "Please input the name of the route")
                return
            }
            break
        default:
            break
        }
        switchView.status = status.next(type: switchView.type)
    }
}

class StoreSceneViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var switchView: SwitchView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    
    let route = Route()
    
    var status:OperationStatus = .locating
    
    var last: SCNVector3? = nil
    
    lazy var configuration = { () -> ARWorldTrackingConfiguration in
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
//        configuration.isLightEstimationEnabled = false
        return configuration
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
        // Set the scene to the view
        sceneView.scene = SCNScene()
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        switchView.type = .store
        switchView.delegate = self
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
        DispatchQueue.main.async {
            if .going == self.status {
                guard let pointOfView = self.sceneView.pointOfView else { return }
                
                let current = pointOfView.position
                if let last = self.last {
                    if last.distance(vector: current) >= Constant.ROUTE_DOT_INTERVAL*Constant.SCALE_INTERVAL {
                        NodeUtil.addNormalNode(rootNode: self.sceneView.scene.rootNode, current: current, last: last);
                        self.last = current
                    }
                } else {
                    NodeUtil.addBeginNode(rootNode: self.sceneView.scene.rootNode, position: current)
                    self.last = current
                }
                
                glLineWidth(0)
            }
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
        sceneView.session.run(configuration)
    }
}
