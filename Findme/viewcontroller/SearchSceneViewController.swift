//
//  SearchSceneViewController.swift
//  Findme
//
//  Created by zhengperry on 2017/9/24.
//  Copyright © 2017年 mmoaay. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

extension SearchSceneViewController {
}

extension SearchSceneViewController: SwitchViewDelegate {
    func switched(status: OperationStatus) {
        switch status {
        case .locating:
            sceneView.scene = route.scene
            // Run the view's session
            sceneView.session.run(configuration, options: .resetTracking)
            break
        case .going:
            imageView.isHidden = true
            break
        case .done:
            navigationController?.popViewController(animated: true)
            break
        default:
            break
        }
        
        switchView.status = status.next(type: switchView.type)
    }
}

class SearchSceneViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var switchView: SwitchView!
    @IBOutlet weak var imageView: UIImageView!
    
    var route = Route()
    
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
//        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
        // Set the scene to the view
        sceneView.scene = SCNScene()
    
        // Run the view's session
        sceneView.session.run(configuration)
        
        switchView.type = .search
        switchView.delegate = self
        
        imageView.image = route.image
    }
    
    @IBAction func sharePressed(_ sender: UIBarButtonItem) {
        ShareUtil.shared.shareRoute(shareItem: sender, identity: route.identity)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        let node = SCNNode()
//
//        return node
//    }
    
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
