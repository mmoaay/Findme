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
}
