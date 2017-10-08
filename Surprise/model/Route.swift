//
//  Route.swift
//  Surprise
//
//  Created by zhengperry on 2017/10/4.
//  Copyright © 2017年 mmoaay. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class Route: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.time, forKey: "time")
        aCoder.encode(self.scene, forKey: "scene")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.scene = aDecoder.decodeObject(forKey: "scene") as! SCNScene
        self.time = aDecoder.decodeObject(forKey: "time") as! NSDate
    }
    
    init(name: String, time: NSDate, scene: SCNScene) {
        self.name = name
        self.scene = scene
        self.time = time
    }
    
    override init() {
        super.init()
    }
    
    var name = ""
    var time = NSDate()
    var scene = SCNScene()
}


