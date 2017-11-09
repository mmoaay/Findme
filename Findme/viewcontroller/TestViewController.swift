//
//  TestViewController.swift
//  Findme
//
//  Created by ZhengYidong on 09/11/2017.
//  Copyright © 2017 mmoaay. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SwiftLocation
import CoreLocation

class TestViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    var location:CLLocation? = nil
    
    var request:LocationRequest!
    
    lazy var configuration = { () -> ARWorldTrackingConfiguration in
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        configuration.isLightEstimationEnabled = false
        return configuration
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
//        sceneView.autoenablesDefaultLighting = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
        // Set the scene to the view
        sceneView.scene = SCNScene()
        
        // Create a session configuration
        // Run the view's session
        sceneView.session.run(configuration, options: .resetTracking)
        
        request = Locator.subscribePosition(accuracy: .room, onUpdate: { [unowned self] (loc) -> (Void) in
            if let location = self.location {
                if loc.distance(from: location) > 20 {
                    // Set the scene to the view
                    self.sceneView.scene = SCNScene(named: "art.scnassets/ship.scn")!
                    
                    // Run the view's session
                    self.sceneView.session.run(self.configuration, options: .resetTracking)
                    self.location = loc
                }
            }
        }) { (err, loc) -> (Void) in
            
        }
    }
    
    deinit {
        Locator.stopRequest(request)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPressed(_ sender: Any) {
//        let anchor = ARAnchor()
//        sceneView.session.add(anchor: anchor)
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        // Set the scene to the view
        sceneView.scene = SCNScene()
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration, options: .resetTracking)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        // Set the scene to the view
        sceneView.scene = SCNScene()
        
        // Create a session configuration
        // Run the view's session
        sceneView.session.run(configuration)
    }

}
