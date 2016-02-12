//
//  Misc.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/27/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation

class Misc {
    class func updateIfChanged<T : Equatable>(inout target : T, source : T) {
        if source != target {
            target = source
        }
    }
    class func updateIfChanged<T : Equatable>(inout target : T?, source : T) {
        if source != target {
            target = source
        }
    }
}