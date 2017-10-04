//
//  Route.swift
//  ARSearcher
//
//  Created by zhengperry on 2017/10/4.
//  Copyright © 2017年 mmoaay. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol Infomationable {
    var title: String { get }
}

enum NodeType{
    case start(info: Infomationable)
    case object(info: Infomationable)
    case route
    
    func title() -> String {
        return ""
    }
}

class Node: Object {
}

class Route: Object {
    @objc dynamic var color: UIColor = UIColor.white
    let dogs = List<Node>()
    let objects = List<Node>()
}


