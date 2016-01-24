//
//  Misc.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/21/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit

//static func join<T : Equatable>(objs: [T], separator: String) -> String {
//    return objs.reduce("") {
//        sum, obj in
//        let maybeSeparator = (obj == objs.last) ? "" : separator
//        return "\(sum)\(obj)\(maybeSeparator)"
//    }
//}

class Error {
    
    enum CustomError : ErrorType {
        case DevelopmentError(String)
    }

    static func throwDevError(message : String) throws {
        throw CustomError.DevelopmentError(message)
    }
    
}

