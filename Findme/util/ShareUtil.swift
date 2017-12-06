//
//  ShareUtil.swift
//  Findme
//
//  Created by ZhengYidong on 02/12/2017.
//  Copyright © 2017 mmoaay. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension ShareUtil: UIDocumentInteractionControllerDelegate {
    
}

class ShareUtil: NSObject {
    static let shared = ShareUtil()
    
    private var document = UIDocumentInteractionController()
    
    func shareRoute(view: UIView, identity: Int64) {
        if let file = FileUtil.path(name: "/com.mmoaay.findme.routes".appending("/").appending(String(identity).appending(".fmr"))) {
            document = UIDocumentInteractionController(url: URL(fileURLWithPath: file))
            document.uti = "com.mmoaay.fmr"
            document.delegate = self
            document.presentOpenInMenu(from: .zero, in: view, animated: true)
//            document.presentOpenInMenu(from: shareItem, animated: true)
        }
    }
    
    func openRoute(file: URL) {
        let identity = FileUtil.identityForFile(file: file.lastPathComponent)
        
        if let route = RouteCacheService.shared.routes[identity] {
            SVProgressHUD.showInfo(withStatus: "Already got the route with name: ".appending(route.name))
            return
        }
        
        if let path = FileUtil.copyFile(at: file), let route = RouteCacheService.shared.getRoute(filePath: path) {
            SVProgressHUD.showInfo(withStatus: "Route with name: ".appending(route.name).appending(" added."))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadRoutes"), object: nil)
        } else {
            SVProgressHUD.showError(withStatus: "Open shared route failed!")
        }
    }
}
