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

class Node: Object {
}

class Route: Object {
    @objc dynamic var color: UIColor = UIColor.white
    let dogs = List<Node>()
    @objc dynamic var name: String = ""
}


