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

class Route: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.identity, forKey: "identity")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.scene, forKey: "scene")
        aCoder.encode(self.image, forKey: "image")
        aCoder.encode(self.origin, forKey: "origin")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.identity = aDecoder.decodeInt64(forKey: "identity")
        if let name = aDecoder.decodeObject(forKey: "name") as? String {
            self.name = name
        }
        if let scene = aDecoder.decodeObject(forKey: "scene") as? SCNScene {
            self.scene = scene
        }
        if let image = aDecoder.decodeObject(forKey: "image") as? UIImage {
            self.image = image
        }
        if let origin = aDecoder.decodeObject(forKey: "origin") as? CLLocation {
            self.origin = origin
        }
    }
    
    init(identity: Int64 = Int64(Date().timeIntervalSince1970), name: String, scene: SCNScene, origin:CLLocation) {
        self.name = name
        self.scene = scene
        self.identity = identity
        self.origin = origin
    }
    
    override init() {
        super.init()
    }
    
    var identity:Int64 = Int64(Date().timeIntervalSince1970)
    var name = ""
    var scene = SCNScene()
    var origin = CLLocation()
    var image = UIImage()
}


