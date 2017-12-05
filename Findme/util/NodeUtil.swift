//
//  NodeUtil.swift
//  Findme
//
//  Created by ZhengYidong on 05/12/2017.
//  Copyright © 2017 mmoaay. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class NodeUtil {
    private static func vertexCoordinates() -> [CGPoint] {
        return [CGPoint(x: 0, y: 0),
                CGPoint(x: 20, y: 0),
                CGPoint(x: 20, y: 10),
                CGPoint(x: 10, y: 10),
                CGPoint(x: 10, y: 20),
                CGPoint(x: 0, y: 20)
        ]
    }
    
    private static func arrowPath() -> UIBezierPath {
        let path = UIBezierPath()
        let points = NodeUtil.vertexCoordinates()
        
        var count = 0
        for point in points {
            if 0 == count {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
            count += 1
        }
        
        path.close()
        
        return path
    }
    
    static func addBeginNode(rootNode:SCNNode, position: SCNVector3) {
        let box = SCNBox(width: CGFloat(Constant.BOX_SIZE*Constant.SCALE_INTERVAL), height: CGFloat(Constant.BOX_SIZE*Constant.SCALE_INTERVAL), length: CGFloat(Constant.BOX_SIZE*Constant.SCALE_INTERVAL), chamferRadius: 0)
        let node = SCNNode(geometry: box)
        node.position = position
        node.geometry?.firstMaterial?.diffuse.contents = UIColor(hexColor: "CD4F39")
        rootNode.addChildNode(node)
    }
    
    static func addEndNode(rootNode:SCNNode, position: SCNVector3) {
        let box = SCNBox(width: CGFloat(Constant.BOX_SIZE*Constant.SCALE_INTERVAL), height: CGFloat(Constant.BOX_SIZE*Constant.SCALE_INTERVAL), length: CGFloat(Constant.BOX_SIZE*Constant.SCALE_INTERVAL), chamferRadius: 0)
        let node = SCNNode(geometry: box)
        node.position = position
        node.geometry?.firstMaterial?.diffuse.contents = UIColor(hexColor: "CD4F39")
        rootNode.addChildNode(node)
    }
    
    static func addNormalNode(rootNode:SCNNode, current: SCNVector3, last: SCNVector3) {
        let path = NodeUtil.arrowPath()
        let shape = SCNShape(path: path, extrusionDepth: 2)
        
        let node = SCNNode(geometry: shape)
        node.transform = SCNMatrix4MakeScale(Constant.SCALE_INTERVAL, Constant.SCALE_INTERVAL, Constant.SCALE_INTERVAL)
//        node.rotation = SCNVector4Make(Float.pi/2.0*3.0, Float.pi/4.0+atan2(current.x-last.x, current.z-last.z), 0.0, 0.0)
        node.runAction(SCNAction.rotateBy(x: CGFloat(Float.pi/2.0*3.0), y:CGFloat(Float.pi/4.0+atan2(current.x-last.x, current.z-last.z)), z: 0.0, duration: 0.0))
        
        node.position = current
        node.geometry?.firstMaterial?.diffuse.contents = UIColor(hexColor: "43CD80")
        rootNode.addChildNode(node)
    }
}
