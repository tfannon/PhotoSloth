//
//  ArrayExtensions.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/24/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation

extension Array{
    func each(each: (Element) -> ()){
        for object: Element in self {
            each(object)
        }
    }
    
    /**
     Difference of self and the input arrays.
     
     :param: values Arrays to subtract
     :returns: Difference of self and the input arrays
     */
    func difference <T: Equatable> (values: [T]...) -> [T] {
        
        var result = [T]()
        
        elements: for e in self {
            if let element = e as? T {
                for value in values {
                    //  if a value is in both self and one of the values arrays
                    //  jump to the next iteration of the outer loop
                    if value.contains(element) {
                        continue elements
                    }
                }
                
                //  element it's only in self
                result.append(element)
            }
        }
        
        return result
        
    }

    func any(condition : (Array.Element) -> Bool) -> Bool {
        for x in self {
            if condition(x) {
                return true
            }
        }
        return false
    }
    
    var any: Bool {
        return !self.isEmpty
    }
    
    func count(condition : (Array.Element) -> Bool) -> Int {
        var count = 0
        for x in self {
            if condition(x) {
                count += 1
            }
        }
        return count
    }
}

extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}
