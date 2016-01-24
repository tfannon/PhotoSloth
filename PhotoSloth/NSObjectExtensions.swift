//
//  NSObjectExtensions.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/24/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
    }
}
