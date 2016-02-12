//
//  Locks.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/27/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation

class Lock {
    
    let obj = NSObject()
    
    func lock(block : () -> ()) {
        objc_sync_enter(obj)
        block()
        objc_sync_exit(obj)
    }
    
}