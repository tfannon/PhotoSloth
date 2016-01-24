//
//  StringExtensions.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/24/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation

extension String {
    var length : Int {
        return self.characters.count
    }
    
    func equalsCI(other : String) -> Bool {
        return self.caseInsensitiveCompare(other) == .OrderedSame
    }
    
    func substring(numberOfChars: Int) -> String
    {
        return (self as NSString).substringToIndex(numberOfChars)
    }
    func substringFrom(startingIndex: Int) -> String
    {
        return (self as NSString).substringFromIndex(startingIndex)
    }
    
    func startsWith(string: String) -> Bool
    {
        let range = (self as NSString).rangeOfString(string, options:.CaseInsensitiveSearch)
        return range.location == 0
    }
    
    // http://brettbukowski.github.io/SwiftExamples/examples/strings/
    func endsWith (string: String) -> Bool {
        if let range = self.rangeOfString(string, options:[.BackwardsSearch, .CaseInsensitiveSearch]) {
            return range.endIndex == self.endIndex
        }
        return false
    }
    
    func contains(string: String) -> Bool
    {
        let range = (self as NSString).rangeOfString(string, options:.CaseInsensitiveSearch)
        return range.location == 0
    }
    
    func indexOfCharacter(char: Character) -> Int? {
        if let idx = self.characters.indexOf(char) {
            return self.startIndex.distanceTo(idx)
        }
        return nil
    }
    
    func hasTwoOrMore(char: Character) -> Bool {
        var count : Int = 0
        for c in self.characters {
            if (c == char) {
                count++
                if count >= 2 {
                    return true
                }
            }
        }
        return false
    }
    
    func toDouble() -> Double {
        let converter = NSNumberFormatter()
        if let result = converter.numberFromString(self) {
            return result.doubleValue
        }
        return 0
    }
    
    func replace(findString: String, withString: String) -> String {
        let toArray = self.componentsSeparatedByString(findString)
        let result = toArray.joinWithSeparator(withString)
        return result
    }
}
