//
//  Random.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/24/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation

class Random {
    static func getItem<T>(array : Array<T>) -> T {
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        return array[randomIndex]
    }
}