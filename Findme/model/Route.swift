//
//  Route.swift
//  Findme
//
//  Created by zhengperry on 2017/10/4.
//  Copyright © 2017年 mmoaay. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import CoreLocation

class Segment: NSObject, NSSecureCoding  {
    var scene = SCNScene()
    var origin = CLLocation()
    
    init(scene: SCNScene, origin:CLLocation) {
        self.scene = scene
        self.origin = origin
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.scene, forKey: "scene")
        aCoder.encode(self.origin, forKey: "origin")
    }
    
    required init(coder aDecoder: NSCoder) {
        if let scene = aDecoder.decodeObject(forKey: "scene") as? SCNScene {
            self.scene = scene
        }
        if let origin = aDecoder.decodeObject(forKey: "origin") as? CLLocation {
            self.origin = origin
        }
    }
}

class Route: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.identity, forKey: "identity")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.image, forKey: "image")
        aCoder.encode(self.segments, forKey: "segments")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.identity = aDecoder.decodeInt64(forKey: "identity")
        if let name = aDecoder.decodeObject(forKey: "name") as? String {
            self.name = name
        }
        if let image = aDecoder.decodeObject(forKey: "image") as? UIImage {
            self.image = image
        }
        if let segments = aDecoder.decodeObject(forKey: "segments") as? [Segment] {
            self.segments = segments
        }
    }
    
    init(identity: Int64 = Int64(Date().timeIntervalSince1970), name: String, segments: [Segment]) {
        self.name = name
        self.segments = segments
        self.identity = identity
    }
    
    override init() {
        super.init()
    }
    
    var identity:Int64 = Int64(Date().timeIntervalSince1970)
    var name = ""
    var image = UIImage()
    var segments: [Segment] = []
}


