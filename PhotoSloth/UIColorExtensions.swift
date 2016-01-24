//
//  UIColorExtensions.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/24/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation
import UIKit

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
