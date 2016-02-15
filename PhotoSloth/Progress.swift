//
//  Progress.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 2/15/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation

//
// represents a progress event
//
class Progress {
    private(set) var current : Int = 0
    private(set) var total : Int = 0
    
    lazy var progress : Float = {
        if self.total == 0 {
            return 0
        }
        else {
            return ProgressCalculator.get(self.current, total: self.total)
        }
    }()
    
    init() {
        
    }
    init(current : Int, total : Int) {
        self.current = current
        self.total = total
    }
}