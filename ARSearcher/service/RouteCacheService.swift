//
//  RouteCacheService.swift
//  ARSearcher
//
//  Created by zhengperry on 2017/10/4.
//  Copyright © 2017年 mmoaay. All rights reserved.
//

import Foundation

class RouteCacheService {
    func route(name: String) -> Route {
        return Route()
    }
    
    func route(prefix: String) -> [Route] {
        return []
    }
    
    func addRoute(route: Route) -> Bool {
        return true
    }
}
