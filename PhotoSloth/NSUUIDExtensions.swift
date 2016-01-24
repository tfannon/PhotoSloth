//
//  NSUUIDExtensions.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/24/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation

extension NSUUID {
    static func newUUID() -> String {
        return NSUUID().UUIDString
    }
}
