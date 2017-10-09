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
            // Create a session configuration
            let configuration = ARWorldTrackingConfiguration()
            // Run the view's session
            sceneView.session.run(configuration)
            break
        case .going:
            self.sceneView.scene = self.route.scene
            break
        case .done:
            self.navigationController?.popViewController(animated: true)
            break
        default:
            break
        }
        
        self.switchView.status = status.next(type: self.switchView.type)
    }
}

class SearchSceneViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var switchView: SwitchView!
    
    var route = Route()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set the scene to the view
        sceneView.scene = SCNScene()
        
        sceneView.autoenablesDefaultLighting = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        switchView.type = .search
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
