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
        aCoder.encode(self.identity, forKey: "identity")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.scene, forKey: "scene")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.identity = aDecoder.decodeInt64(forKey: "identity")
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.scene = aDecoder.decodeObject(forKey: "scene") as! SCNScene
    }
    
    init(identity: Int64 = Int64(Date().timeIntervalSince1970), name: String, scene: SCNScene) {
        self.name = name
        self.scene = scene
        self.identity = identity
    }
    
    override init() {
        super.init()
    }
    
    var identity:Int64 = Int64(Date().timeIntervalSince1970)
    var name = ""
    var scene = SCNScene()
    var header = UIImage()
}


