//
//  Random.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/24/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation

class Random {
    // returns a random element from the array
    static func getItem<T>(array : Array<T>) -> T {
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        return array[randomIndex]
    }
    
    // returns a random number between startingValue and endingValue (inclusive)
    static func get(startingValue : Int, endingValue : Int) -> Int {
        let range = endingValue - startingValue + 1
        let random = Int(arc4random_uniform(UInt32(range)))
        return startingValue + random
    }
}