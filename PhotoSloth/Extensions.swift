//
//  Extensions.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/2/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    var className: String {
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
    }
}

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
}

extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}

extension NSDate {
    func ToLongDateStyle() -> String {
        return self.toString(dateStyle: NSDateFormatterStyle.LongStyle, timeStyle: NSDateFormatterStyle.NoStyle)
    }
}

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

extension UITableView {
    func clear() {
        var set = [Int]()
        for i in 0...self.numberOfSections {
            set.append(i)
        }
        self.deleteSections(NSIndexSet.fromArray(set), withRowAnimation: .None)
    }
}

extension UITableViewCell {
    func enable(on: Bool) {
        self.userInteractionEnabled = on
        self.selectionStyle = .None
        for view in contentView.subviews {
            view.userInteractionEnabled = on
            view.alpha = on ? 1 : 0.5
        }
    }

    /// Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            
            return table as? UITableView
        }
    }
}

//used for putting something into string format for wire transfer
extension NSData {
    func getEncodedString() -> String? {
        return self.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    }
    
    class func fromEncodedString(str: String) -> NSData? {
        return NSData(base64EncodedString: str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
    }
}

extension Array {
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
                count++
            }
        }
        return count
    }
}

extension NSIndexPath {
    func getNextRow() -> NSIndexPath {
        return getRelativeRow(1)
    }
    func getRelativeRow(deltaRow : Int) -> NSIndexPath {
        let ip = NSIndexPath(forRow: self.row + deltaRow, inSection: self.section)
        return ip
    }
    func getNextSection() -> NSIndexPath {
        return getRelativeSection(1)
    }
    func getRelativeSection(deltaSection : Int) -> NSIndexPath {
        let ip = NSIndexPath(forRow: row, inSection: self.section + deltaSection)
        return ip
    }
    class var firstElement: NSIndexPath {
        return NSIndexPath(forRow: 0, inSection: 0)
    }
}

extension NSIndexSet {
    class func fromArray(set : [Int]) -> NSIndexSet {
        let ret = NSMutableIndexSet()
        for i in set {
            ret.addIndex(i)
        }
        return NSIndexSet(indexSet: ret)
    }
}

extension UITableView {
    func dequeueReusableCellWithNibName(nibName : String!) -> UITableViewCell? {
        var cell = self.dequeueReusableCellWithIdentifier(nibName)
        if (cell == nil) {
            self.registerNib(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
            cell = self.dequeueReusableCellWithIdentifier(nibName)
        }
        return cell
    }
}

extension UIViewController {
    func alert(title : String?, message : String?) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension NSTimer {
    /**
     Creates and schedules a one-time `NSTimer` instance.
     
     - Parameters:
     - delay: The delay before execution.
     - handler: A closure to execute after `delay`.
     
     - Returns: The newly-created `NSTimer` instance.
     */
    class func schedule(delay delay: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
    
    /**
     Creates and schedules a repeating `NSTimer` instance.
     
     - Parameters:
     - repeatInterval: The interval (in seconds) between each execution of
     `handler`. Note that individual calls may be delayed; subsequent calls
     to `handler` will be based on the time the timer was created.
     - handler: A closure to execute at each `repeatInterval`.
     
     - Returns: The newly-created `NSTimer` instance.
     */
    class func schedule(repeatInterval interval: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
}

extension UIColor {
    func RGB() -> String {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var a : CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return "RGB(\(Int(r * 255)), \(Int(g * 255)), \(Int(b * 255))"
        }
        return "n/a"
    }
    
    func betweenColor(color: UIColor) -> UIColor {
        var r1 : CGFloat = 0
        var g1 : CGFloat = 0
        var b1 : CGFloat = 0
        var a1 : CGFloat = 0
        var r2 : CGFloat = 0
        var g2 : CGFloat = 0
        var b2 : CGFloat = 0
        var a2 : CGFloat = 0
        
        if self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            && color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        {
            let r3 = (r1 + r2) / 2.0
            let g3 = (g1 + g2) / 2.0
            let b3 = (b1 + b2) / 2.0
            return UIColor(red: r3, green: g3, blue: b3, alpha: a1)
        }
        
        return self
    }
    
    func darkerColor(percentage: CGFloat = 0.1) -> UIColor {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var a : CGFloat = 0
 
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            r = max(r * (1.0 - percentage), 0)
            g = max(g * (1.0 - percentage), 0)
            b = max(b * (1.0 - percentage), 0)
            return UIColor(red: r , green: g, blue: b, alpha: a)
        }
        return self
    }

    func lighterColor(percentage: CGFloat = 0.1) -> UIColor {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var a : CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            r = min(r * (1.0 + percentage), 255)
            g = min(g * (1.0 + percentage), 255)
            b = min(b * (1.0 + percentage), 255)
            return UIColor(red: r , green: g, blue: b, alpha: a)
        }
        return self
    }
}

