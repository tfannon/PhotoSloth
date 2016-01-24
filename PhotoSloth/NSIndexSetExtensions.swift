//
//  NSIndexSetExtensions.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/24/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation

extension NSIndexSet {
    class func fromArray(set : [Int]) -> NSIndexSet {
        let ret = NSMutableIndexSet()
        for i in set {
            ret.addIndex(i)
        }
        return NSIndexSet(indexSet: ret)
    }
}
