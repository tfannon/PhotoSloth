//
//  UITableViewExtensions.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/24/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func clear() {
        var set = [Int]()
        for i in 0...self.numberOfSections {
            set.append(i)
        }
        self.deleteSections(NSIndexSet.fromArray(set), withRowAnimation: .None)
    }
    func dequeueReusableCellWithNibName(nibName : String!) -> UITableViewCell? {
        var cell = self.dequeueReusableCellWithIdentifier(nibName)
        if (cell == nil) {
            self.registerNib(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
            cell = self.dequeueReusableCellWithIdentifier(nibName)
        }
        return cell
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
