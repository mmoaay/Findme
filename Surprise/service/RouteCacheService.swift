//
//  RouteCacheService.swift
//  Surprise
//
//  Created by zhengperry on 2017/10/4.
//  Copyright © 2017年 mmoaay. All rights reserved.
//

import Foundation
import SceneKit

class RouteCacheService {
    static let shared = RouteCacheService()
    
    init() {
        if let file = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending("/com.mmoaay.surprise.routes"), let routes = NSKeyedUnarchiver.unarchiveObject(withFile: file) as? [Route]{
            self.routes = routes
        }
    }
    
    var routes: [Route] = []
    
    func route(name: String) -> Route? {
        for route in routes {
            if name == route.name {
                return route
            }
        }
        return nil
    }
    
    func routes(prefix: String) -> [Route] {
        return self.routes.filter { (route) -> Bool in
            return route.name.contains(prefix)
        }
    }
    
    @discardableResult
    func addRoute(route: Route) -> Bool {
        routes.append(route)
        return archive()
    }
    
    func archive() -> Bool {
        if let file = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending("/com.mmoaay.surprise.routes") {
            return NSKeyedArchiver.archiveRootObject(routes, toFile: file)
        }
        return false
    }
}
