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
        FileUtil.createFolder(name: "/com.mmoaay.findme.routes")
        getAllRoutes()
    }
    
    func getAllRoutes() {
        if let path = FileUtil.path(name: "/com.mmoaay.findme.routes") {
            let files = FileUtil.allFiles(path: path, filterTypes: ["fmr"])
            for file in files {
                let filePath = path.appending("/").appending(file)
                getRoute(filePath: filePath)
            }
        }
    }
    
    @discardableResult
    func getRoute(filePath: String) -> Route? {
        if let route = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Route {
            routes[String(route.identity)] = route
            return route
        } else {
            return nil
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
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadRoutes"), object: nil)
        
        if let file = FileUtil.path(name: "/com.mmoaay.findme.routes".appending("/").appending(String(route.identity).appending(".fmr"))) {
            return NSKeyedArchiver.archiveRootObject(route, toFile: file)
        } else {
            return false
        }
    }
    
    @discardableResult
    func delRoute(route: Route) -> Bool {
        routes.removeValue(forKey: String(route.identity))
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadRoutes"), object: nil)
        
        if let file = FileUtil.path(name: "/com.mmoaay.findme.routes".appending("/").appending(String(route.identity).appending(".fmr"))) {
            return FileUtil.delFile(path: file)
        } else {
            return false
        }
    }
}
