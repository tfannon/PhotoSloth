//
//  NSDataExtensions.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/24/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation

//used for putting something into string format for wire transfer
extension NSData {
    func getEncodedString() -> String? {
        return self.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    }
    
    class func fromEncodedString(str: String) -> NSData? {
        return NSData(base64EncodedString: str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
    }
}
