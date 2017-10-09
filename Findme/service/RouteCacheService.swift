//
//  RouteCacheService.swift
//  Findme
//
//  Created by zhengperry on 2017/10/4.
//  Copyright © 2017年 mmoaay. All rights reserved.
//

import Foundation
import SceneKit

class RouteCacheService {
    static let shared = RouteCacheService()
    
    init() {
        if let file = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending("/com.mmoaay.findme.routes"), let routes = NSKeyedUnarchiver.unarchiveObject(withFile: file) as? [String : Route]{
            self.routes = routes
        }
    }
    
    var routes: [String : Route] = [ : ]
    
    func route(identity: Int64) -> Route? {
        return routes[String(identity)];
    }
    
    func routes(prefix: String) -> [Route] {
        return Array(self.routes.values).filter { (route) -> Bool in
            return route.name.lowercased().contains(prefix.lowercased())
        }
    }
    
    func allRoutes() -> [Route] {
        return Array(self.routes.values)
    }
    
    @discardableResult
    func addRoute(route: Route) -> Bool {
        routes[String(route.identity)] = route
        return archive()
    }
    
    @discardableResult
    func delRoute(route: Route) -> Bool {
        routes.removeValue(forKey: String(route.identity))
        return archive()
    }
    
    private func archive() -> Bool {
        if let file = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending("/com.mmoaay.findme.routes") {
            return NSKeyedArchiver.archiveRootObject(routes, toFile: file)
        }
        return false
    }
}
