//
//  File.swift
//  PhotoDeclutter_1
//
//  Created by Adam Rothberg on 1/23/16.
//  Copyright © 2016 Adam Rothberg. All rights reserved.
//

import Foundation

class File {
    
    static var documentDirectory : NSURL {
        get {
            let v = NSSearchPathForDirectoriesInDomains(
                NSSearchPathDirectory.DocumentDirectory,
                NSSearchPathDomainMask.UserDomainMask,
                true)
            return NSURL(fileURLWithPath: v[0])
        }
    }
    
    static func combine(url : NSURL, strings : String...) -> NSURL {
        var url = NSURL(fileURLWithPath: url.absoluteString)
        for i in 1..<strings.count {
            let string = strings[i]
            url = url.URLByAppendingPathComponent(string)
        }
        return url
    }
    
    static func createDirectory(url : NSURL) {
        try! NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
    }
    
    static func deleteDirectory(url : NSURL) {
        if exists(url) {
            try! NSFileManager.defaultManager().removeItemAtPath(url.fileSystemString)
        }
    }
    
    static func exists(url: NSURL) -> Bool {
        let manager = NSFileManager.defaultManager()
        return manager.fileExistsAtPath(url.fileSystemString)
    }
}

extension NSURL {
    func combine(strings : String...) -> NSURL {
        var url = NSURL(fileURLWithPath: self.absoluteString)
        for string in strings {
            url = url.URLByAppendingPathComponent(string)
        }
        return url
    }
    
    var fileSystemString : String {
        get {
            return self.resourceSpecifier
        }
    }
}