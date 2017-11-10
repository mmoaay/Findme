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
import CoreLocation

extension StoreSceneViewController: SwitchViewDelegate {
    func switched(status: OperationStatus) {
        self.status = status
        switch status {
        case .locating:
            if let currentFrame = self.sceneView.session.currentFrame, let image = UIImage(pixelBuffer: currentFrame.capturedImage, context:CIContext()) {
                route.image = image
                sceneView.session.run(self.configuration, options: .resetTracking)
                request = Locator.subscribePosition(accuracy: .room, onUpdate: { [unowned self] (loc) -> (Void) in
                    
                    if loc.horizontalAccuracy < Constant.HORIZONTAL_ACCURACY_FILTER || loc.verticalAccuracy < Constant.VERTICAL_ACCURACY_FILTER {
                        return
                    }
                    
                    if let location = self.location {
                        print(loc.verticalAccuracy, loc.horizontalAccuracy)
                        print(loc.distance(from: location))
                        if loc.distance(from: location) > Constant.LOCATION_INTERVAL && loc.timestamp.timeIntervalSince1970 - location.timestamp.timeIntervalSince1970 > Constant.LOCATION_INTERVAL/Constant.STEP_INTERVAL {
                            self.route.segments.append(Segment(scene: self.sceneView.scene, origin: location))
                            
                            // Set the scene to the view
                            self.sceneView.scene = SCNScene()
                            // Run the view's session
                            self.sceneView.session.run(self.configuration, options: .resetTracking)
                            self.location = loc
                        }
                    } else {
                        self.location = loc
                    }
                }) { (err, loc) -> (Void) in
                }
            } else {
                return
            }
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
            
            if let location = location {
                self.route.segments.append(Segment(scene: self.sceneView.scene, origin: location))
            }
            location = nil
            sceneView.scene = SCNScene()
            
            self.nameView.isHidden = false
            self.nameTextField.becomeFirstResponder()
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
        switchView.status = status.next(type: self.switchView.type)
    }
}

class StoreSceneViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var switchView: SwitchView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    
    let route = Route()
    
    var request:LocationRequest?
    var location:CLLocation? = nil
    
    var status:OperationStatus = .locating
    
    var last: SCNVector3? = nil
    
    lazy var configuration = { () -> ARWorldTrackingConfiguration in
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        configuration.isLightEstimationEnabled = false
        return configuration
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
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
    
    deinit {
        if let request = request {
            Locator.stopRequest(request)
        }
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
            
            last = current
            
            glLineWidth(0)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        sceneView.session.pause()
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        sceneView.session.run(configuration)
    }
}
