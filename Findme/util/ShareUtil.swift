//
//  ShareUtil.swift
//  Findme
//
//  Created by ZhengYidong on 02/12/2017.
//  Copyright © 2017 mmoaay. All rights reserved.
//

import Foundation
import UIKit

extension ShareUtil: UIDocumentInteractionControllerDelegate {
    
}

class ShareUtil: NSObject {
    static let shared = ShareUtil()
    
    private var document = UIDocumentInteractionController()
    
    func shareRoute(shareItem:UIBarButtonItem, identity: Int64) {
        if let file = FileUtil.path(name: "/com.mmoaay.findme.routes".appending("/").appending(String(identity).appending(".fmr"))) {
            document = UIDocumentInteractionController(url: URL(fileURLWithPath: file))
            document.delegate = self
            document .presentOpenInMenu(from: shareItem, animated: true)
        }
    }
}
