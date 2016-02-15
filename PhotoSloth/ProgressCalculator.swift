//
//  ProgressCalculator.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/24/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation

//
// functions that all return a number between 0..1 representing the progress
//
class ProgressCalculator {
    class func get(current : Float, total : Float) -> Float {
        let d = current / total
        return d
    }
    class func get(current : Int, total : Int) -> Float {
        return get(Float(current), total: Float(total))
    }
    class func get(current : Int64, total : Int64) -> Float {
        return get(Float(current), total: Float(total))
    }
}

