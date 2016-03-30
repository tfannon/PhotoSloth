//
//  UserSettings.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/25/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation

class UserSettings {
    
    static var mockGoogle : Bool {
        get {
            return get(#function) ?? false
        }
        set {
            set(#function, value : newValue)
        }
    }
    static var delayGather : Int? {
        get {
        return get(#function)
        }
        set {
            set(#function, value : newValue)
        }
    }
    static var delayGatherBetween : Int? {
        get {
        return get(#function)
        }
        set {
            set(#function, value : newValue)
        }
    }
    
    private static func get<T>(key : String) -> T? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(key) as? T
    }
    private static func set(key : String, value : AnyObject?)  {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey: key)
        defaults.synchronize()
    }
}
