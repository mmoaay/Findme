//
//  FileUtil.swift
//  Findme
//
//  Created by ZhengYidong on 02/12/2017.
//  Copyright © 2017 mmoaay. All rights reserved.
//

import Foundation

class FileUtil {
    static func allFiles(path: String, filterTypes: [String]) -> [String] {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: path)
            if filterTypes.count == 0 {
                return files
            } else {
                let filteredfiles = NSArray(array: files).pathsMatchingExtensions(filterTypes)
                return filteredfiles
            }
        } catch {
            return []
        }
    }
    
    static func path(name: String) -> String? {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending(name)
    }
    
    static func createFolder(name: String) {
        if let path = path(name: name) {
            if false == FileManager.default.fileExists(atPath: path) {
                try! FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }
        }
    }
    
    static func delFile(path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch {
            return false
        }
        return true
    }
    
    static func identityForFile(file: String) -> String {
        var identity = file
        let names = file.components(separatedBy: "-")
        if names.count > 1 {
            identity = names[0]
        } else {
            let names = file.components(separatedBy: ".")
            if names.count > 1 {
                identity = names[0]
            }
        }
        return identity
    }
    
    static func copyFile(at: URL) -> String? {
        do {
            let identity = FileUtil.identityForFile(file: at.lastPathComponent)
            if let path = FileUtil.path(name: "/com.mmoaay.findme.routes".appending("/").appending(identity).appending(".fmr")) {
                try FileManager.default.copyItem(at: at, to: URL(fileURLWithPath: path))
                return path
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
